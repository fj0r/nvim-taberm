### {{{ base.nu
$env.comma_scope = {|_|{ created: '2024-05-18{6}14:02:49' }}
$env.comma = {|_|{}}
### }}}

'sync'
| comma fun {
    rsync -avp ./ ~/world/nvim-taberm/ --exclude=.git
}

