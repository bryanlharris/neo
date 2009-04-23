_neo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="help version search rdp ssh pix --help --version"

    case "${prev}" in
        search)
            search_opts="showpasswords --showpasswords $(neo search . | grep -v ^- | awk '{print $2}') $(neo search . | grep -v ^- | awk '{print $3}')"
            COMPREPLY=( $(compgen -W "${search_opts}" -- ${cur}) )
            return 0
            ;;
        ssh)
            ssh_opts="screen --screen $(neo search . | grep -v ^- | awk '{print $2}') $(neo search . | grep -v ^- | awk '{print $3}')"
            COMPREPLY=( $(compgen -W "${ssh_opts}" -- ${cur}) )
            return 0
            ;;
        rdp)
            rdp_opts="console --console $(neo search . | grep -v ^- | awk '{print $2}') $(neo search . | grep -v ^- | awk '{print $3}')"
            COMPREPLY=( $(compgen -W "${rdp_opts}" -- ${cur}) )
            return 0
            ;;
        pix)
            pix_opts="$(neo search . | grep -v ^- | awk '{print $2}') $(neo search . | grep -v ^- | awk '{print $3}')"
            COMPREPLY=( $(compgen -W "${pix_opts}" -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _neo neo
