#include <unistd.h>
#include <errno.h>

/* Author: n0decaf
 * Thanks to ippsec
 */

int main(int argc, const char * argv[]){
    if (argc > 1) printf("%2", execvp(argv[1], &argv[1]));
    return 0;
}
