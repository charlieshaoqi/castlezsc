#!/bin/bash
# 指定shell类型
# 启用 Readline
set -o emacs
# 启用 Bash tab 补全功能
#source /etc/bash_completion

LoggedInUsername=`whoami`
# 已登录的用户名

echo -e "\033[34m输入help来查看帮助！！！\033[0m"

while true
do 

pwd=`pwd`
# pwd变量

echo -n "[${LoggedInUsername}->TestOS:${pwd}]# "
# 参数-n的作用是不换行，echo默认换行

read error                                  
# 把键盘输入放入变量error

now_pwd=$(pwd)
cd ~
if [ "${error}" != "" ]
then
    echo "${error}" >> .myhistory_
fi
cd ${now_pwd}
# history

################################################
if [ "${error}" = "quit" ]
then
    echo "正在退出..."
    exit
    # 退出命令
fi

################################################
if [ "${error}" = "" ]
then
    echo -n ""
    # 换行设定 
fi

################################################
:<<zhushi
if [ "${error:0:2}" = "ls" ]
then
    ls_=${error:3}
    if [ "${ls_}" = "-a" ]
    then
        ls -a
    else
        if [ "${ls_}" = "-l" ]
        then
            ls -l
        else
            if [ "${ls_}" = "-al" ]
            then
                ls -al
            else
                if [ "${ls_}" = "" ]
                then
                    ls
                else
                    if [ "${ls_}" = "-h" ]
                    then
                        echo "usage: ls [-alh]"
                    else
                        echo "usage: ls [-alh]"
                    fi
                fi
            fi                
        fi                
    fi                    
fi
# 列出当前文件
zhushi

################################################
if [ "${error}" = "ls" ]
then
    ls
fi
# ls命令

################################################
if [ "${error:0:2}" = "ls" ] && [ "${error:2:1}" = " " ]
then
    # 处理 ls 命令的参数
    ls_=${error:3}

    if [ "${ls_:0:1}" = "-" ]
    then
        # 处理参数选项
        if [ "${ls_}" = "-a" ]
        then
            ls -a

        elif [ "${ls_}" = "-l" ]
        then
            ls -l

        elif [ "${ls_}" = "-al" ]
        then
            ls -al

        elif [ "${ls_}" = "-h" ]
        then
            echo "usage: ls [-alh] [path/to/search]"
        else
            echo "\033[31mERR!\033[0m ls: illegal option ${ls_}"
        fi
    elif [ -e "./${ls_}" ]
    then
        # 如果输入是一个已存在的文件或目录，直接显示该文件或目录的信息
        ls "./${ls_}"

    else
        # 如果输入不是一个有效的参数选项或文件名，提示用户输入错误
        echo -e "\033[31mERR!\033[0m No such file or directory: ${ls_}"
    fi
fi
# ls命令

################################################
if [ "${error:0:5}" = "echo " ]
then
    echo_=${error:5}
    if [ "${error}" = "echo -h" ]
    then 
        # echo help
        echo "列出文件，echo [string ...]，单引号；双引号；不加引号；变量等等均可打印"
    elif [[ ${error:5} =~ '"'(.*)'"' ]]
    then
        # 使用双引号包含
        echo "$(eval echo ${BASH_REMATCH[1]})"
    elif [[ ${error:5} =~ ^\'*([^\']*?)\'*$ ]]
    then
        # 使用单引号包含
        echo "${BASH_REMATCH[1]}"
    elif [ "${error:0:5}" = "echo " ]
    then
        # 直接输出变量
        echo "$(eval echo "${error:5}")"
    else
        # 无效参数
        echo -e "\033[31mERR!\033[0m echo: illegal option ${echo_}"
    fi
fi
# echo命令

################################################
if [ "${error}" = "cd" ]
then
    cd
fi

if [ "${error:0:3}" = "cd " ]
then 
    if [ "${error:3}" = "-h" ]
    then
        echo "进入到指定目录，usage: cd [dir]，直接打cd回到home目录"
    else
    cd_="${error:3}"
    cd ${cd_}
    fi
fi
# cd命令

################################################
if [ "${error:0:6}" = "mkdir " ]
then
    mkdir ${error:6}
fi
# mkdir命令创建目录

################################################
if [ "${error:0:6}" = "touch " ]
then
    touch ${error:6}
fi
# touch命令创建文件

################################################
if [ "${error:0:6}" = "rm -r " ]
then
    rm -r ${error:6}
fi
# rm删除目录

################################################
if [ "${error:0:6}" = "rm -f " ]
then
    rm -f ${error:6}
fi
# rm删除文件

################################################
if [ "${error}" = "rm -h" ]
then
    echo "usage: rm [-f | -r] [file ... unlink file]（-r为删除目录「注意rm -r是递归删除，很危险，删错了就回不来了」，-f为删除文件）"
fi
# rm help

################################################
if [ "${error:0:4}" = "vim " ]
then
    vim ${error:4}
fi
# 使用vim编辑文件

if [ "${error:0:3}" = "vi " ]
then
    vi ${error:3}
fi
# 使用vi编辑文件
################################################
:<<EOF
if [ "${error:0:4}" = "cat " ] && [ "${error:4:1}" = ">" ] && [ "${error:0-0:5}" = "<<EOF" ]
then

fi
# cat命令重定向
EOF
#不使用，做不到

################################################
if [ "${error:0:4}" = "cat " ]
then
    cat ${error:4}
fi
# cat命令查看文件内容

################################################
if [ "${error}" = "ifconfig" ]
then 
    ifconfig
    # ifconfig命令显示当前网络配置信息
fi

if [ "${error}" = "ping" ]
then
    echo -n "请输入要ping的地址："
    read ip
    ping -c 3 $ip
    # 对输入的地址进行ping测试
fi

################################################
if [ "${error}" = "history" ]
then
    cd ~
    cat .myhistory_
    cd ${now_pwd}
fi
# 查看历史记录

################################################
if [[ "${error:0:3}" == "mv " ]]; then
    mv_file1=${error#mv } # 从$error中删除'mv '得到文件路径
    mv_file1="${mv_file1%% *}" # 将文件路径按空格拆分后取第一个部分赋值给$mv_file1
    mv_file2="${error#*${mv_file1} }" # 用$mv_file1做前缀从$error中删除得到第二个文件路径
    mv "$mv_file1" "$mv_file2"
fi
# mv命令

################################################
if [[ "${error:0:3}" == "cp " ]]; then
    cp_file1=${error#cp } # 从$error中删除'cp '得到文件路径
    cp_file1="${cp_file1%% *}" # 将文件路径按空格拆分后取第一个部分赋值给$cp_file1
    cp_file2="${error#*${cp_file1} }" # 用$cp_file1做前缀从$error中删除得到第二个文件路径
    if [[ -d $cp_file1 ]]; then
        cp -r "$cp_file1" "$cp_file2"
    elif [[ -f $cp_file1 ]]; then
        cp "$cp_file1" "$cp_file2"
    else
        echo -e "\033[31mERR!\033[0m 没有源文件，复制失败"
    fi
fi
# cp命令

################################################
if [ "${error}" = "help" ]
then 
    #echo "quit（退出） ; ls (列出文件，输入ls -h以获得更多的帮助); echo（答应文本、变量等） ; cd ; mkdir ; touch ; rm (rm -r)(rm -f) ; vim ; cat (cat>filename<<EOF); ifconfig ; ping ; help "
    echo -e "\033[31mquit\033[0m（退出）"
    sleep 0.1
    echo -e "\033[31mls\033[0m (列出文件，\033[32m输入ls -h以获得更多的帮助\033[0m)"
    sleep 0.1
    echo -e "\033[31mecho\033[0m（打印文本、变量等，\033[32m输入echo -h以获得更多的帮助\033[0m）"
    sleep 0.1
    echo -e "\033[31mcd\033[0m（进入到指定目录，\033[32m输入cd -h以获得更多的帮助\033[0m）"
    sleep 0.1
    echo -e "\033[31mmkdir\033[0m（创建文件夹，\033[34musage: mkdir [directory ...]\033[0m）"
    sleep 0.1
    echo -e "\033[31mtouch\033[0m（生成一个空白文件，\033[34musage: [file ...]\033[0m）"
    sleep 0.1
    echo -e "\033[31mrm\033[0m（删除文件，\033[32m输入rm -h以获得更多的帮助\033[0m）"
    sleep 0.1
    echo -e "\033[31mvim/vi\033[0m（编辑/生成文件），现在功能并不多，只能\033[34m|vim/vi 文件名|\033[0m，所以没有vim/vi的help"
    sleep 0.1
    echo -e "\033[31mcat\033[0m（只能打印文件，无法修改文件）\033[34m(usage: cat [file ..])----|print flie ..|\033[0m"
    sleep 0.1
    echo -e "\033[31mifconfig\033[0m（显示网卡信息）"
    sleep 0.1
    echo -e "\033[31mping\033[0m（测试IP地址，\033[34m直接输入ping后看提示输入\033[0m）"
    sleep 0.1
    echo -e "\033[31mhistory\033[0m（历史记录，\033[34m直接输入history来打印历史记录\033[0m）"
    sleep 0.1
    echo -e "\033[31mmv\033[0m（移动文件/更改文件(夹)名），\033[34musage: mv [source] [target] // mv [source] [directory]\033[0m"
    sleep 0.1
    echo -e "\033[31mcp\033[0m（复制文件），\033[34musage: cp [source_file] [target_file] // cp [source_file] [target_directory]\033[0m"
fi
# help

################################################
if [ "${error}" != "quit" ] && [ "${error:0:3}" != "ls " ] && [ "${error}" != "ls" ] && [ "${error:0:5}" != "echo " ] && [ "${error:0:3}" != "cd " ] && [ "${error}" != "cd" ] && [ "${error:0:6}" != "mkdir " ] && [ "${error:0:6}" != "touch " ] && [ "${error:0:6}" != "rm -r " ] && [ "${error:0:6}" != "rm -f " ] && [ "${error}" != "rm -h" ] && [ "${error:0:4}" != "vim " ] && [ "${error}" != "ifconfig" ] && [ "${error}" != "ping" ] && [ "${error}" != "" ] && [ "${error}" != "help" ] && [ "${error:0:4}" != "cat " ] && [ "${error}" != "history" ] && [ "${error:0:3}" != "mv " ] && [ "${error:0:3}" != "cp " ]
then
    #echo "无效输入：${error}"
    echo "-Test_OS: ${error}: command not found"
fi
done