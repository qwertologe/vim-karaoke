" File:          karaoke.vim
" Author:        Michael Arlt
" Version:       1.00
" Description:   Karaoke
"
" Copyright (C) 2019  Michael Arlt
"
" vim-karaoke is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" vim-karaoke is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
"                For more help see karaoke.txt; you can do this by using:
"                :helptags ~/.vim/doc
"                :h karaoke.txt

function! KaraokeOn()
  nnoremap <silent> <Space> :call Karaoke()<CR>
  nnoremap <silent> <Up> :call KaraokePreviousLine()<CR>
  nnoremap <silent> <Down> :call KaraokeNextLine()<CR>
  nnoremap <silent> <PageUp> :call KaraokePreviousPage()<CR>
  nnoremap <silent> <PageDown> :call KaraokeNextPage()<CR>
  nnoremap <silent> <Return> :call KaraokeThisLine()<CR>
  nnoremap <silent> - :call KaraokeChangeSpeed(-1)<CR>
  nnoremap <silent> + :call KaraokeChangeSpeed(1)<CR>
  let g:Karaoke_active = 1
endfunction

function! KaraokeOff()
  silent unmap <Space>
  silent unmap <Up>
  silent unmap <Down>
  silent unmap <PageUp>
  silent unmap <PageDown>
  silent unmap <Return>
  silent unmap -
  silent unmap +
  let g:Karaoke_active = 0
endfunction

function! KaraokeSwap()
  let g:Karaoke_active = get(g:, 'Karaoke_active', 0)
  if g:Karaoke_active
    call KaraokeOff()
    call KaraokeSay(get(g:, 'Karaoke_off_msg', "bye"))
  else
    call KaraokeOn()
    call KaraokeSay(get(g:, 'Karaoke_on_msg', "ready"))
  endif
endfunction

function! KaraokeSay(text)
  let g:Karaoke_speed = get(g:, 'Karaoke_speed', 15)
  let g:Karaoke_cursor_focus = get(g:, 'Karaoke_cursor_focus', 0)
  redraw!
  if g:Karaoke_cursor_focus
    sleep 1m
  endif
  call system("say " . printf("%1.1f",g:Karaoke_speed/10.0),a:text)
  redraw!
endfunction

function! Karaoke()
  try
    call KaraokeOn()
    let last_line_number = line('$')
    let g:Karaoke_sleep = 0
    call KaraokeThisLine()
    while line('.') < last_line_number
      call KaraokeNextLine()
    endwhile
  catch /./
    unlet g:Karaoke_sleep
    redraw!
  endtry
endfunction

function! KaraokeNextLine()
  call setpos('.',[0,line('.')+1,1,0])
  call KaraokeThisLine()
endfunction

function! KaraokePreviousLine()
  call setpos('.',[0,line('.')-1,1,0])
  call KaraokeThisLine()
endfunction

function! KaraokePreviousPage()
  let g:Karaoke_page_regex = get(g:, 'Karaoke_page_regex', "^# Seite ")
  call search(g:Karaoke_page_regex,'b')
  call KaraokeThisLine()
endfunction

function! KaraokeNextPage()
  let g:Karaoke_page_regex = get(g:, 'Karaoke_page_regex', "^# Seite ")
  call search(g:Karaoke_page_regex)
  call KaraokeThisLine()
endfunction

function! KaraokeThisLine()
  "call KaraokeSay(expand("<cword>"))
  call KaraokeSay(getline('.'))
endfunction

function! KaraokeChangeSpeed(step)
  let g:Karaoke_speed = get(g:, 'Karaoke_speed', 10)
  let l:Karaoke_speed = g:Karaoke_speed + a:step
  if l:Karaoke_speed >= 10 && l:Karaoke_speed <= 20
    let g:Karaoke_speed = l:Karaoke_speed
    call KaraokeSay(printf("%1.1f",g:Karaoke_speed/10.0))
  endif
endfunction

nnoremap <silent> <C-@> :call KaraokeSwap()<CR>
" vim:noet:sw=2:ts=2:ft=vim
