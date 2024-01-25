#!/usr/bin/python3

import re
import subprocess
import asyncio
import signal
import time
import threading
import logging

"""
Python script for monitoring for new a4c containers and maintaining an SSH
remote forwarding tunnel for clipper. Each minute, the main thread runs 'a4c
containers --nicknames-only', reconciling the resulting list of containers
against a set of threads (one per container). Each thread spawns an SSH tunnel
which forwards remote localhost:8377 to local port 8377.

To restart:

   launchctl unload -w -S Aqua ~/Library/LaunchAgents/com.joshpfosi.clipper_mon.plist
   launchctl load -w -S Aqua ~/Library/LaunchAgents/com.joshpfosi.clipper_mon.plist

UPDATE:

   I've modified this to just start a tunnel to us219, and added a 'clipman'
   script in ~/.local/bin/clipman which ssh's to us219 if on another server
   (thanks Appu!).
"""

USER_SERVER = 'us219.sjc.aristanetworks.com'
exitNow = False

def handler( signum, frame ):
   global exitNow
   logging.info( 'Ctrl-C handled; shutting down gracefully' )
   exitNow = True

class TunnelManager( object ):
   def __init__( self ):
      logging.debug( 'Starting TunnelManager' )
      self.duration = 10
      self.processByCntr = {}

   def run( self ):
      logging.debug( f'TunnelManager:run' )
      attempt = 0
      while not exitNow:
         if USER_SERVER not in self.processByCntr:
            self.startTunnel( USER_SERVER )
         for cntr, process in self.processByCntr.items():
            logging.debug( f'{cntr}: process.returncode={process.returncode}' )
            # Restart the tunnel periodically or if it failed.
            self.stopTunnel( cntr )
            self.startTunnel( cntr )
         logging.debug( f'Sleeping for {self.duration}s' )
         time.sleep( self.duration )
         attempt += 1

      logging.info( 'Shutting down all tunnels' )
      for cntr in self.processByCntr:
         self.stopTunnel( cntr )

   def startTunnel( self, cntr ):
      assert cntr == USER_SERVER
      logging.debug( f'startTunnel: container={cntr}: Starting tunnel')
      # Use -4 as we don't need an IPV6 tunnel as well. Makes the kill of sshd
      # easier later.
      opts = ' '.join( [
            '-o "UserKnownHostsFile=/dev/null"',
            '-o "StrictHostKeyChecking=no"',
            '-N',
            '-R 8377:127.0.0.1:8377',
      ] )
      cmd = f'ssh {opts} {cntr}'
      logging.debug( f'Attempting: {cmd}' )
      proc = subprocess.Popen( cmd, shell=True )
      # Wait 5 seconds to see if the tunnel starts up
      try:
         ret = proc.wait( timeout=2 )
      except subprocess.TimeoutExpired:
         # If the command times out, it suggests the tunnel is running
         logging.info( f'Starting tunnel for {cntr} succeeded' )
         self.processByCntr[ cntr ] = proc
      else:
         logging.info( f'Starting tunnel for {cntr} failed; try killing sshd' )
         try:
            cmd = f"ssh {USER_SERVER} 'sudo netstat -4pnl'"
            proc = subprocess.run( cmd, shell=True, capture_output=True,
                                   check=True )
            lines = proc.stdout.splitlines()
            regex = "tcp.*127.0.0.1:8377.*LISTEN.*\s(\d*)\/sshd.*$"
            pid = None
            for line in lines:
               line = str( line, encoding='ascii' )
               match = re.match( regex, line )
               if match:
                  pid = int( match.groups()[ 0 ] )
                  break
            if pid:
               # Kill sshd and try again
               cmd = f"ssh {USER_SERVER} 'kill -9 {pid}'"
               subprocess.run( cmd, shell=True, capture_output=True, check=True )
               logging.debug( f'Killed sshd pid={pid}' )
            else:
               logging.error( 'Failed to kill sshd: Could not find pid' )
         except subprocess.CalledProcessError:
            logging.error( 'Failed to kill sshd; trying again later' )

   def stopTunnel( self, cntr ):
      assert cntr == USER_SERVER
      # Gracefully end thread
      logging.debug( f'stopTunnel: container={cntr}: Stopping tunnel')
      self.processByCntr[ cntr ].terminate()

   def containers( self ):
      logging.debug( 'TunnelManager:containers' )
      with open( '/Users/joshpfosi/.a4c-containers', 'r' ) as f:
         return set( cntr.strip() for cntr in f.readlines() )

if __name__ == '__main__':
   LOG_FILE = '/Users/joshpfosi/.clipper_mon.log'
   logging.basicConfig( filename=LOG_FILE, level=logging.DEBUG )
   signal.signal( signal.SIGINT, handler )
   TunnelManager().run()
   logging.info( 'Exiting gracefully' )
