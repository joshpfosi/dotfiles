if did_filetype()
   finish
endif
if getline(line('$')) =~ 'review description'
   setfiletype gitcommit
endif

