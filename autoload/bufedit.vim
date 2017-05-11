if exists("g:done_bufedit_autoload")
  finish
endif
let g:done_bufedit_autoload = 1

function! s:buffers()
  let bnum = 1
  let buflist = []
  while bnum <= bufnr("$")
    if bufexists(bnum) && buflisted(bnum)
      call add(buflist, bufname(bnum))
    endif
    let bnum = bnum + 1
  endwhile
  return buflist
endfunction

if !exists("g:bufedit_buffer_name")
  let g:bufedit_buffer_name = "**Buffer-List**"
endif

function! s:resetcontent()
  let b:buffer_list = s:buffers()
  normal! ggVGd
  call append(0, b:buffer_list)
  normal! ddgg
  setlocal nomodified
endfunction

function! s:bufopts()
  setlocal nobuflisted
  setlocal noswapfile
  call s:resetcontent()
endfunction

function! s:getlines()
  let lnum = 1
  let lines = []
  while lnum <= line("$")
    let l = getline(lnum)
    if strlen(l) > 0
      call add(lines, l)
    endif
    let lnum = lnum + 1
  endwhile
  return lines
endfunction

function! s:getremovals()
  let keep = s:getlines()
  let purge = []
  for l:buffer in b:buffer_list
    if index(keep, l:buffer) == -1
      call add(purge, l:buffer)
    endif
  endfor
  return purge
endfunction

function! s:purge()
  let purge_list = s:getremovals()
  for purge in purge_list
    execute "bw ".fnameescape(purge)
  endfor
  call s:resetcontent()
endfunction

function! bufedit#write()
  let destination = expand("<amatch>")
  if (fnamemodify(destination, ":t") == g:bufedit_buffer_name)
    call s:purge()
  else
    let bang = v:cmdbang ? "!" : ""
    execute "saveas".bang." ".destination
    execute "bw! ".g:bufedit_buffer_name
    au! bufedit
  endif
endfunction

function! bufedit#open()
  execute "new ".g:bufedit_buffer_name
  call s:bufopts()
  augroup bufedit
    au!
    au BufWriteCmd <buffer> call bufedit#write()
  augroup END
endfunction
