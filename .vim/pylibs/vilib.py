import os
import socket
import subprocess
import threading

thesocket = None
vim_tmux_window = None
port = None

def viexit():
   if vim_tmux_window:
      print "Closing tmux window %s" % vim_tmux_window
      os.system('tmux kill-pane -t %s' % vim_tmux_window )

def visend(cmd):
   if thesocket is not None:
      thesocket.sendall(cmd.encode('utf-8'))

def vicommand(cmdstring):
   cmdstring = '["ex","%s"]' % cmdstring
   visend(cmdstring)

def visetline(lineno):
   vicommand( "call Markline(%d)"%lineno )
   vicommand( "redraw" )

def visync( filename, linenum, column=0 ):
   cmdstring = 'view %s' % filename
   vicommand(cmdstring)
   visetline(linenum)

def launch_vim():
   if port:
      nsstring = ''
      if 'NSNAME' in os.environ:
         nsstring = 'netns %s ' % os.environ[ 'NSNAME' ]

      vimcommand = '%svim -c "let handle = ch_open(\'localhost:%d\') "' % \
                     (nsstring, port )
      cmdargs = [ 'tmux', 'split-window', '-Pd', vimcommand ]
      global vim_tmux_window

      # get the name of the created pane to later kill it during the exit hook
      vim_tmux_window = subprocess.check_output(cmdargs)
   else:
      print "do not have a port for vim to connect to. please call setup_socket() first"

def accept_connection(s):
   print "       waiting for connection"
   conn, addr = s.accept()
   print 'got connection', addr
   global thesocket
   thesocket = conn

def setup_socket():
   TCP_IP = 'localhost'
   TCP_PORT = 0
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.bind((TCP_IP, TCP_PORT))
   s.listen(1)
   global port
   port = s.getsockname()[1]
   print "Listening on port {0} for a connection from a vi session".format(port)
   t = threading.Thread( target=accept_connection, args=(s,) )
   t.daemon = True
   t.start()

   print "To start a synced vi session:"
   print "    1) run launch_vim command in your gdb/pdb prompt. or.."
   print " or 2) run the below command in your existing vi session."
   print "       let handle = ch_open(\'localhost:%d\')" % port
