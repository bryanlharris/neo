_neo()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="help version search rdp ssh pix --help --version"

    case "${prev}" in
        search)
            COMPREPLY=( $(compgen -W "${search_opts}" -- ${cur}) )
            return 0
            ;;
        ssh)
            COMPREPLY=( $(compgen -W "${ssh_opts}" -- ${cur}) )
            return 0
            ;;
        rdp)
            COMPREPLY=( $(compgen -W "${rdp_opts}" -- ${cur}) )
            return 0
            ;;
        pix)
            COMPREPLY=( $(compgen -W "${pix_opts}" -- ${cur}) )
            return 0
            ;;
        --showpasswords)
            COMPREPLY=( $(compgen -W "${showpasswords_opts}" -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

export search_opts="showpasswords --showpasswords $(neo search . | awk '{print tolower($1),tolower($2)}')"
export ssh_opts="$(neo search . | awk '{print tolower($1),tolower($2)}')"
export rdp_opts="$(neo search . | awk '{print tolower($1),tolower($2)}')"
export pix_opts="$(neo search . | awk '{print tolower($1),tolower($2)}')"
export showpasswords_opts="$(neo search . | awk '{print tolower($1),tolower($2)}')"
complete -o default -F _neo neo
