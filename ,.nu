export def 'sync' [] {
    rsync -avp ./ ~/world/nvim-taberm/ --exclude=.git
}
