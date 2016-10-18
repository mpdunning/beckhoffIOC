/* file: bkh5ASub.c
 * EPICS asub routines.
 * This asub is used to convert a "raw" voltage reading to vacuum pressure.
 *----------------------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <dbDefs.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#ifndef MIN
#define MIN(a,b)        (((a)<(b))?(a):(b))
#endif

static long bkh5Init( aSubRecord* pr){
  printf( "bkh5Init: %s\n",pr->name);
  return(0);
}
static long bkh5Convert( aSubRecord* pr){
/*------------------------------------------------------------------------------
 * This routine converts an input value to vaccum pressure.  The formula is
 *   p=A*exp(B*v)
 * Inputs:
 *  a	coefficient A
 *  b	coefficient B
 *  c	raw value v
 * Outputs:
 *  vala	converted value
 *----------------------------------------------------------------------------*/
  double* pa=(double*)pr->a;
  double* pb=(double*)pr->b;
  double* pv=(double*)pr->c;
  double* pout=(double*)pr->vala;
static int cnt; double ex;

  ex=exp(*pb*(*pv));
  *pout=(*pa)*exp(*pb*(*pv));
if(!cnt) printf("%s, a=%g, b=%g, v=%g, ex=%g, y=%g\n",pr->name,
	 *pa,*pb,*pv,ex,*pout);
cnt=1;
  return(0);
}
epicsRegisterFunction( bkh5Init);
epicsRegisterFunction( bkh5Convert);
