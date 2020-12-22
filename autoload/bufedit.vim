if exists("g:done_bufedit_autoload")
  finish
endif
let g:done_bufedit_autoload = 1

function! s:bufnums()
  let bnum = 1
  let buflist = []
  while bnum <= bufnr("$")
    if bufexists(bnum) && buflisted(bnum)
      call add(buflist, bnum)
    endif
    let bnum = bnum + 1
  endwhile
  return buflist
endfunction

function! s:buffers()
  let buflist = []
  for bnum in s:bufnums()
    call add(buflist, bufname(bnum))
  endfor
  return buflist
endfunction

if !exists("g:bufedit_buffer_name")
  let g:bufedit_buffer_name = "**Buffer-List**"
endif

function! s:isnoname(bnum)
  return bufname(a:bnum) ==# ''
endfunction

function! s:ismodified(bnum)
  return getbufvar(a:bnum, "&modified")
endfunction

function! s:isunused(bnum)
  return s:isnoname(a:bnum) && ! s:ismodified(a:bnum)
endfunction

" TODO
" - load unsaved buffers into qf list

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

function! s:getunused()
  let buflist = []
  for bnum in s:bufnums()
    if s:isunused(bnum)
      call add(buflist, bnum)
    end
  endfor
  return buflist
endfunction

function! s:getmodified()
  let buflist = []
  for l:bnum in s:bufnums()
    if s:ismodified(l:bnum)
      call add(buflist, l:bnum)
    endif
  endfor
  return buflist
endfunction

" a:blist can be a list of bnums, or filenames/paths
function! s:purgebuffers(blist)
  for l:buffer in a:blist
    if type(l:buffer) ==# v:t_number
      execute "bw " . l:buffer
    elseif type(l:buffer) ==# v:t_string
      execute "bw " . fnameescape(l:buffer)
    else
      throw "Invalid buffer argument type (this is a bug in bufedit.vim)"
    endif
  endfor
endfunction

function! s:purgeremoved()
  call s:purgebuffers(s:getremovals())
  call s:resetcontent()
endfunction

function! s:purgeunused()
  call s:purgebuffers(s:getunused())
endfunction

function! bufedit#write()
  call s:purgeunused()
  let destination = expand("<amatch>")
  if (fnamemodify(destination, ":t") == g:bufedit_buffer_name)
    call s:purgeremoved()
  else
    let bang = v:cmdbang ? "!" : ""
    execute "saveas".bang." ".destination
    execute "bw! ".g:bufedit_buffer_name
    au! bufedit
  endif
endfunction

function! bufedit#open()
  call s:purgeunused()
  execute "new ".g:bufedit_buffer_name
  call s:bufopts()
  call s:resetcontent()
  augroup bufedit
    au!
    au BufWriteCmd <buffer> call bufedit#write()
  augroup END
endfunction

function! bufedit#unsavedtoqf()
  let qflist = []
  for l:bnum in s:getmodified()
    call add(qflist, {'bufnr': l:bnum})
  endfor
  call setqflist(qflist, 'r')
  if len(qflist) > 0
    cfirst
    copen
  else
    echom "No unsaved changes"
  end
endfunction
