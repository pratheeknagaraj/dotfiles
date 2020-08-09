# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

bind -f ~/.bash_key_bindings

alias usage='du -d 3 -ch --time | sort -hr | less'

alias home='cd /home/pnagaraj'
alias memory_leak='ps --sort -rss -eo rss,pid,command | head'
alias server='python3 -m http.server'
alias cores='cd /var/tmp/'

alias newest='ls -Art | tail -n 1'
alias randomfile='ls -Art | shuf -n 1'
alias random='randomfile'
alias datefmt='date +\%Y\%m\%d_\%H\%M\%S'
alias colors='for x in 0 1 4 5 7 8; do for i in `seq 30 37`; do for a in `seq 40 47`; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";'

alias spacetime='echo -ne "\033[31m"; printf %100s | tr " " "="; echo -ne "\033[32m\n"; date; echo -ne "\033[0m"; echo -ne "\033[31m"; printf %100s | tr " " "="; echo -ne "\033[0m\n"'
alias ptree='tree -CF'
alias extract='/home/pnagaraj/bin/extract'
alias length='wc -l'
alias less='less -RC'
alias today='date --date="today" +%Y%m%d'

ulimit -c unlimited

# Space commands
alias space='echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"'
alias break='a=`tput cols`; yes "=" | head -$a | paste -s -d "" -'
alias timepoint='a=`tput cols`; b1=$((a/2-16+1)); b2=$((a/2-16)); c1=$(printf "%-${b1}s" "-"); c2=$(printf "%-${b2}s" "-"); echo -ne `echo "\033[30;41m""${c1// /-}"`"[""\033[0m""\033[1;37;41m" `date` "\033[0m""\033[30;41m""]"`echo "${c2// /-}\033[0m"`'
alias pointtime='a=`tput cols`; b1=$((a/2-16+1)); b2=$((a/2-16)); c1=$(printf "%-${b1}s" "-"); c2=$(printf "%-${b2}s" "-"); echo -ne `echo "\033[30;42m""${c1// /-}"`"[""\033[0m""\033[1;37;42m" `date` "\033[0m""\033[30;42m""]"`echo "${c2// /-}\033[0m"`'
alias tp='timepoint'
alias pt='pointtime'

# --- Math --- #

alias count_sort='sort | uniq -c | sort -nr'
alias sort_count='sort | uniq -c | sort -nr'
alias sort_count_csv='sort | uniq -c | sort -nr | awk '"'"'{print $1 "," $2}'"'"''
alias add='awk '"'"'{ total += $1 } END { print total }'"'"''
alias total='awk '"'"'{ total += $1 } END { print total }'"'"''
alias mean='awk '"'"'{ sum += $1; n++ } END { if (n > 0) print sum / n; }'"'"''
alias nonzero='awk '"'"'{ if ($1 > 0) n++ } END { print n; }'"'"''
alias average='awk '"'"'{ sum += $1; n++ } END { if (n > 0) print sum / n; }'"'"''
alias qstats='/home/pnagaraj/qstats/bin/qstats'

function len() {
    awk '{ print length }'
}

function pctdiff() {
    awk -v t1="$1" -v t2="$2" 'BEGIN{print (t2-t1)/t1 * 100}'
}

function dict_count() {
    awk '{key=$1; vals[key] += $2} END { for ( key in vals ) { print key" "vals[key]; } }' | sort -k 2 -r -n
}

function rand() {
    sort -R | tail -$1
}

function rand_num() {
    echo "$RANDOM / 32767" | bc -l
}

# --- Network --- #

function my_ip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# --- Git --- #

alias git_summary='git shortlog -s -n'
alias git_summary_email='git log --format='%ae' | sort_count | less'
alias gitpp='git pull --rebase origin master; git push'                 # Pull, Push

function gitplog() {
    git log --graph --pretty=format:'%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%>(20)%aI %C(auto,green)%<(12,trunc)%aN%C(auto,reset)%s%C(auto,red)% gD% D' --abbrev-commit $@
}

function gitplog2() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

function gitcrb() {
    echo "Checking out master, resetting to master, pulling and rebasing, and creating new branch" $1;
    git checkout master; git reset --hard origin/master; git pull --rebase origin master; git checkout -b $1;
}

function gitcr() {
    echo "Checking out master, resetting to master, pulling and rebasing";
    git checkout master; git reset --hard origin/master; git pull --rebase;
}

function gitpr() {
    echo "Pull Rebasing";
    git pull --rebase;
}

function git_author() {
    echo "Listing authors and counts for file/directory: " $1;
    git log --pretty=format:"%an%x09" $1 | sort | uniq -c | sort -n -r;
}

function git_author_date_old() {
    git log --author $1 --pretty=format:'%ci' | rev | cut -c 15- | rev | sort | uniq -c | sort -n -r | awk {'print $2 " " $1'} | sort -r | (awk {'printf "\033[1;32m%s: \033[0m\033[1;34m", $1; for(c=0;c<$2;c++) printf "*"; printf "\033[0m\033[1;31m %s\033[0m\n", $2'}) | less
}

# Common paths

function keep_trying_gitpp() {
    counter=1
    echo -ne "\033[32mRunning (" $counter "): git pull --rebase && git push\033[0m\n"
    git pull --rebase && git push
    while [ $? -ne 0 ];
    do
        counter=$((counter+1))
        echo -ne "\033[32mRunning (" $counter "): git pull --rebase && git push\033[0m\n"
        git pull --rebase && git push
    done
}

function keep_trying_sleep_gitpp() {
    sleep_secs=$1
    counter=1
    echo -ne "\033[32mRunning (" $counter "): git pull --rebase && git push\033[0m\n"
    git pull --rebase && git push
    while [ $? -ne 0 ];
    do
        echo ""
        echo "Sleeping for:" ${sleep_secs} "seconds"
        sleep ${sleep_secs}
        counter=$((counter+1))
        echo -ne "\033[32mRunning (" $counter "): git pull --rebase && git push\033[0m\n"
        git pull --rebase && git push
    done
}

function pjq() {
    cat $1 | sed "s/\/\/.*$//g" | jq .
}

function uncomment() {
    cat $1 | sed "s/\/\/.*$//g" 
}

function unix_to_time() {
    gawk '{print strftime("%c", $0)}'
}

# this emulates the mac 'open' command, which figures out fromthe
# file how to 'display' a file
#
# gnome-open   kde-open    xdg-open

function open() {
    if [ $* > 0 ] ; then
      if [ -d $1 ] ; then
        nautilus -w $1
      else
        xdg-open $*
      fi
    else
      nautilus .
    fi
}

function line() {
    cat - | head -$1 | tail -1
}

function fcat() {
    tail -n +1 $1
}

function read_csv() {
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } 1' $1 | column -s, -t | less -#2 -N -S
}

function cat_csv() {
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } 1' $1 | column -s, -t | cat 
}

function print_csv() {
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } 1' $1 | column -s, -t | cat 
}

function read_csv2() {
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(";", "", $i) } 1' $1 | column -s\; -t | less -#2 -N -S
}

function read_csv3() {
    awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub("|", "", $i) } 1' $1 | column -s\| -t | less -#2 -N -S
}

function read_csv4() {
    column -t | less -#2 -N -S
}

function read_pnl_csv() {
    if [ -n "$2" ]; then
        sort_csv -k $2 -g -r $1 | read_csv
    else
        sort_csv -k 5 -g -r $1 | read_csv
    fi
}

function csv_header() {
    head -1 $1 | tr ',' '\n' | read_csv
}

function csv_header2() {
    head -1 $1 | tr ';' '\n' | read_csv
}

function csv_header3() {
    head -1 $1 | tr '|' '\n' | read_csv
}

function read_csv_header() {
   vim -R -u NONE -N +'map <right> 2zl
                    map <left> 2zh
                    map q :qa<CR>
                    se nu sbo=hor scb nowrap
                    1sp
                    winc w
                   ' <(sed -e "s/,,/, ,/g" $1|column -ts,) 
}

function xls_to_csv() {
    libreoffice --headless --convert-to csv $1 --outdir $2
}

function read_xml() {
     xmllint --pretty 1 $1 | less
}

function read_zstd() {
     zstd -c -d $1 | less
}

function zstdd() {
    zstd --rm -d $1
}

alias zstdless='read_zstd'
alias zstd_less='read_zstd'

function lower(){
    read text
    echo $text | tr '[:upper:]' '[:lower:]'
}

function upper(){
    read text
    echo $text | tr '[:lower:]' '[:upper:]'
}

function strip_space() {
    awk '{$1=$1};1'
}

function trim() {
    awk '{$1=$1};1'
}

function python-profile() {
    python -m cProfile  -s time $*
}

function replace() {
    for i in $(ls -1); do if [[ $i == *"$1"* ]]; then mv -v $i `echo $i | sed "s/$1/$2/g"`; fi; done
}

function remove_trailing_whitespace() {
    sed -i 's/[ \t]*$//' $1;
}

function valid_json() {
    a=`jq . $1 2>&1 >/dev/null | grep 'error'`
    if [[ -z $a ]];
    then 
        echo -e "\033[42;37mVALID JSON\033[0m";
    else
        echo -e "\033[41;37mINVALID JSON\033[0m";
        echo -e "\033[31m\t"$a "\033[0m";
    fi
}

function usage_depth() {
    du -d $1 -ch --time | sort -hr | less
}

function hr() {
    numfmt --to=iec
}

# --- RATES --- #

function rate() {
    curl -s "https://finance.yahoo.com/quote/$1$2%3DX" | grep -o regularMarketPrice............................................. | cut -d '"' -f 7 | head -1
}

# Aliases for functions

alias xml_read='read_xml'
alias csv_read='read_csv'
alias csv_sort='sort -t ,'
alias sort_csv='sort -t ,'
alias validate_json='valid_json'
alias json_check='valid_json'
alias json='valid_json'

# More Aliases

alias o='open'
alias c='clear'
alias pwdf='readlink -f'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias l.='ls -d .* --color=auto'
alias l='ls --color=auto'
alias lh='ls -lhS'
alias lt='ls -lht'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias bc='bc -l'

alias sha1='openssl sha1'

alias mkdir='mkdir -pv'

alias diff='colordiff'

alias mount='mount |column -t'

alias tgz='tar -zxvf'
alias tbz='tar -jxvf'

alias ptest='py.test --flakes'

# handy short cuts #
alias h='history'
alias j='jobs -l'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias vi=vim
alias svi='sudo vi'
alias vis='vim "+set si"'
alias edit='vim'

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
 
# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
 
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


## pass options to free ## 
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop## 
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

alias wget='wget -c'

alias browser='google-chrome'

## set some other defaults ##
alias df='df -H'
alias du='du -ch'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Multitail
alias mt='multitail --config ~/.multitail -n 10000 -M 0 -CS python'
alias log='mt'

## Other ##

function bbc()
{
    curl -s http://feeds.bbci.co.uk/news/rss.xml | grep "<title>" | sed "s/ <title><\!\[CDATA\[//g;s/\]\]><\/title>//;" | grep -v "BBC News" | strip_space | nl
}

function watch_bbc()
{
    watch --interval 300 'curl -s http://feeds.bbci.co.uk/news/rss.xml | grep "<title>" | sed "s/ <title><\!\[CDATA\[//g;s/\]\]><\/title>//;" | grep -v "BBC News" | nl'
}

## User Program Environment Variables ##

export PKG_CONFIG_PATH=/home/pnagaraj/bin/pkgconfig

## Programming languages ##

# golang #
export GOROOT=/usr/lib/golang
export GOPATH=$HOME/programs/go
export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/programs/node/bin:$PATH

export EDITOR="/usr/bin/vim"

