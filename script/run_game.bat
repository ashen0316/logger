set NODE=1
set COOKIE=logger
set NODE_NAME=logger%NODE%@127.0.0.1

set SMP=auto
set ERL_PROCESSES=102400

werl +P %ERL_PROCESSES% -smp %SMP% +S 4 -env ERL_MAX_PORTS 5000 -pa ../ebin -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -s logger_app start
