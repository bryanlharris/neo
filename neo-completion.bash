_neo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="help version search rdp ssh pix"

    case "${prev}" in
        search)
            search_opts="showpasswords"
            COMPREPLY=( $(compgen -W "${search_opts}" -- ${cur}) )
            return 0
            ;;
        ssh)
            ssh_opts="screen"
            COMPREPLY=( $(compgen -W "${ssh_opts}" -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _neo neo
