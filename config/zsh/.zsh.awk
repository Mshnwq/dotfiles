# Takes a list of commands with timing information and displays the elapsed
# time for each one.
#
# The input is expected to look like
#
#     +1518804574.3228740692 colors:76> local k
#     +1518804574.3228929043 colors:77> k=44
#     +1518804574.3229091167 colors:77> color[${color[$k]}]=44
#     +1518804574.3229229450 colors:77> k=33
#     +1518804574.3229279518 colors:77> color[${color[$k]}]=33
#
# Everything between the leading "+" and the next space is taken to be a
# decimal number of seconds with at least microsecond precision (i.e., at least
# six digits after the decimal point). Additional digits are allowed but
# ignored.
#
# The output will look like
#
#     18 colors:76> local k
#     17 colors:77> k=44
#     13 colors:77> color[${color[$k]}]=44
#     5 colors:77> k=33
#
# The first number on each line is the number of microseconds taken by that
# command. (Depending on how you obtain the timing information, the values may
# or may not actually be accurate to the microsecond. This should still give
# you a good idea of the relative timings, though.)
#
# See https://esham.io/2018/02/zsh-profiling for an explanation of the context
# in which this script is intended to be used.
#
# This script was written by Benjamin Esham (https://esham.io) and is released
# under the following terms:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute
# this software, either in source code form or as a compiled binary, for any
# purpose, commercial or non-commercial, and by any means.
#
# In jurisdictions that recognize copyright laws, the author or authors of this
# software dedicate any and all copyright interest in the software to the
# public domain. We make this dedication for the benefit of the public at large
# and to the detriment of our heirs and successors. We intend this dedication
# to be an overt act of relinquishment in perpetuity of all present and future
# rights to this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

function remove_substring(target, str,  start) {
    if (start = index(target, str)) {
        return substr(target, 1, start-1) substr(target, start+length(str))
    } else {
        return target
    }
}

/^\+[0-9]+\.[0-9]{6}[0-9]* / {
    # The input may contain "compound" lines like
    #
    #   +101635.731785 compdef:122> IFS=$' \t' +101635.731877 compdef:122> read -A opt
    #
    # These are produced when Zsh executes a line like
    #
    #   IFS=$' \t' read -A opt
    #
    # Zsh prints separate instances of the trace prompt ($PS4) for the
    # assignment and the command, but does not print a newline between the two.
    # This seems to happen specifically when IFS is being set. In these cases,
    # we manually remove the second trace prompt on the line. The output will
    # contain a single line corresponding to this input line, with the time
    # shown being the total time taken for the IFS assignment and the actual
    # command.
    if (match($0, /IFS=.+:[0-9]+> /)) {
        extra = substr($0, RSTART, RLENGTH)
        if (match(extra, / \+[0-9]+\.[0-9]{6}[0-9]* .+:[0-9]+> $/)) {
            $0 = remove_substring($0, substr(extra, RSTART+1, RLENGTH-1))
        }
    }

    match($0, /\+[0-9]+\./)
    seconds = substr($0, RSTART+1, RLENGTH-2)
    match($0, /\.[0-9]{6}/)
    microseconds = substr($0, RSTART+1, RLENGTH-1)

    this_time = 1000000*seconds + microseconds
    if (previous_time != 0) {
        time_difference = this_time - previous_time
        print time_difference " " previous_command
    }
    previous_time = this_time

    match($0, / .+/)
    previous_command = substr($0, RSTART+1, RLENGTH-1)
}