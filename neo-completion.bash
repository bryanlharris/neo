_neo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="help version search rdp ssh pix --help --version vncpass mkpass"

    case "${prev}" in
        search)
            COMPREPLY=( $(compgen -W "showpasswords ${default_opts}" -- ${cur}) )
            return 0
            ;;
        showpasswords)
            COMPREPLY=( $(compgen -W "${default_opts}" -- ${cur}) )
            return 0
            ;;
        ssh)
            COMPREPLY=( $(compgen -W "--ip ${default_opts}" -- ${cur}) )
            return 0
            ;;
        rdp)
            COMPREPLY=( $(compgen -W "${default_opts}" -- ${cur}) )
            return 0
            ;;
        pix)
            COMPREPLY=( $(compgen -W "${default_opts}" -- ${cur}) )
            return 0
            ;;
        *)
            ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

export default_opts="$(neo search . | awk '{print tolower($2) ".*" $3}') $(neo search . | awk '{print tolower($1) ".*" tolower($2)}')"
complete -o default -F _neo neo
