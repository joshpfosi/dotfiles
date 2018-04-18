# Copyright (c) 2017 Arista Networks, Inc.  All rights reserved.
# Arista Networks, Inc. Confidential and Proprietary.
import vilib as vi
import pdb
import os

def setup_socket(obj,arg):
   vi.setup_socket()

def launch_vim(obj,arg):
   vi.launch_vim()

def start_sync(obj,arg):
   setup_socket(obj,arg)
   launch_vim(obj,arg)

# copied from https://github.com/bitemyapp/ipython/blob/master/IPython/Extensions/ipy_synchronize_with.py
def find_filename(filename):
   """Return the filename to synchronize with based on """
   filename = os.path.splitext(filename)
   if filename[1] == ".pyc":
      filename = (filename[0], ".py")
   filename = "".join(filename)

   if not os.path.isabs(filename):
      filename = os.path.join(os.getcwd(), filename)

   if os.path.isfile(filename):
      return filename

   return ""

def goto(func):
   if not vi.thesocket:
      print "setup socket and vim first using setup_vim"
      return

   import inspect
   if callable(func):
      filename = inspect.getsourcefile(func)
      linenum = inspect.getsourcelines(func)[-1]
      vi.visync( filename, linenum )
   elif not callable(func):
      print "Argument  %s not callable " % func
      return

def print_entry(obj, frame_lineno, prompt_prefix=pdb.line_prefix, context = 4):
   curFrame = obj.stack[obj.curindex]
   if curFrame == frame_lineno:
      frame, lineno =  frame_lineno
      filename = find_filename( frame.f_code.co_filename )
      vi.visync(filename, lineno)
   obj.old_print_stack_entry( frame_lineno, prompt_prefix)

def do_exit(obj, arg):
   vi.viexit()
   return obj.old_do_exit( arg )

def do_goto( obj, line ):
   try:
      goto( obj._getval(line) ) 
   except:
      print "Couldn't goto " + line
      import sys
      print sys.exc_info()

def setup_hook():
   import IPython
   pdb_class = IPython.core.debugger.Pdb
   pdb_class.do_goto = do_goto
   pdb_class.do_launch_vim = launch_vim
   pdb_class.do_setup_socket = setup_socket
   pdb_class.do_start_sync = start_sync

   #setup exit hook
   if pdb_class.do_exit != do_exit:
      pdb_class.old_do_exit = pdb_class.do_exit
      pdb_class.do_exit = do_exit
   #setup quit hook
   if pdb_class.do_quit != do_exit:
      pdb_class.old_do_quit = pdb_class.do_quit
      pdb_class.do_quit = do_exit
   #setup vi sync hook
   if pdb_class.print_stack_entry != print_entry:
      pdb_class.old_print_stack_entry = pdb_class.print_stack_entry
      pdb_class.print_stack_entry = print_entry

   print "Pdb hooks are setup"
   print "1) run setup_socket and launch_vim commands to start a synced vim session"
   print "2) start_sync to do both "

setup_hook()
