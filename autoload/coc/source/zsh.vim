
let s:sourced_filename = expand('<sfile>')
let s:complete_script =  fnamemodify(s:sourced_filename, ':h:h:h:h') . '/bin/capture.zsh'

function! coc#source#zsh#init() abort
  return {
        \ 'filetypes': ['zsh'],
        \ }
endfunction

function! coc#source#zsh#get_startcol(option) abort
  " {'word': 'S'
  "  'bufnr': 1
  "  'col': 7
  "  'triggerCharacter': 'S'
  "  'filepath': '/home/tj/git/config_manager/xdg_config/zsh/custom/spaceship_customize.zsh'
  "  'blacklist': []
  "  'line': 'print $S'
  "  'filetype': 'zsh'
  "  'synname': 'zshDeref'
  "  'input': 'S'
  "  'colnr': 9
  "  'linenr': 12}

  if !has_key(a:option, 'triggerCharacter')
    return a:option.col
  endif

  if a:option.triggerCharacter == '-'
    return a:option.col - 1
  endif

  if strpart(a:option.line, a:option.col - 1, 1) == '$'
    return a:option.col - 1
  endif

  return a:option.col
endfunction

function! coc#source#zsh#complete(opt, cb) abort
  if !executable(s:complete_script)
    return
  end

  let completions = coc#source#zsh#_get_raw_completions(a:opt['line'])

  let items = map(completions,
        \ { k, v ->
          \ len(split(v, ' -- ')) == 1?
            \ { 'word': v }
            \ : { 'word': split(v, ' -- ')[0], 'menu': split(v, ' -- ')[1] }
            \ })

  call a:cb(items)
endfunction

function! coc#source#zsh#_filename() abort
  return s:sourced_filename
endfunction

function! coc#source#zsh#_get_raw_completions(word) abort
  return map(systemlist(s:complete_script . " '" . a:word . "'"), { k, v -> trim(v) })
endfunction
