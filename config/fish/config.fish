if status is-interactive
# Commands to run in interactive sessions can go here
##     alias gst  "git status"
     alias gp  "git pull --rebase"
     alias  ga  "git pull --abort"
     alias chm  "journalctl --user -e"
     alias nvf "nix run ~/bakey-wakey/"
     eval (zellij setup --generate-auto-start fish | string collect)
     starship init fish | source
end

