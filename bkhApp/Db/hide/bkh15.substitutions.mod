# bkh23.substitutions
# BK9000 + KL2531 + KL2541 + KL3162 + KL4032 + KL9010
#-----------------------------------------------------------------
file bkhAdrv.db
{
pattern	{      MOD,   PORT}
	{3162-$(M),  A3162}
	{4032-$(M),  A4032}
#	{2531-$(M),  A2531}
#	{2541-$(M),  A2541}
}
file analogInConv.db
{
pattern { N,ADDR,  DESC,      MOD,  PORT, EGU,EOFF,       ESLO,PREC,EGU2}
	{ 1,   0,Chan01,3162-$(M), A3162,   V,   0,  1,   3,  mm}
	{ 2,   1,Chan02,3162-$(M), A3162,   V,   0,  1,   3,  mm}
}
file bkhDAC.db
{
pattern { N,ADDR,  DESC,      MOD, PORT,EGU,EOFF,       ESLO,PREC}
	{ 1,   0,Chan01,4032-$(M),A4032,  V,   0,0.000305185,   3}
	{ 2,   1,Chan02,4032-$(M),A4032,  V,   0,0.000305185,   3}
}
file readwrite.db
{
pattern	{      MOD,  PORT}
	{3162-$(M), A3162}
#	{2531-$(M), A2531}
#	{2541-$(M), A2541}
	{4032-$(M), A4032}
}
file b9000.db{
	{ RPORT=B900R, WPORT=B900W}
}
file b9000RRegs.db
{
pattern	{ N,                 DESC,  PORT}
	{10,      "PLC Interface", B900R}
	{11, "Bus Term Diagnossi", B900R}
	{12, "Bus Coupler Status", B900R}
	{16, "anlg output length", B900R}
	{17, "anlg inputs length", B900R}
	{18, "Outpt Image length", B900R}
	{19, "Input Image length", B900R}
	{32, "Watchdog curr time", B900R}
}
file b9000WRegs.db
{
pattern	{ N,                 DESC,  PORT}
	{ 0,      "PLC Interface", B900W}
	{ 1, "Bus Term Diagnossi", B900W}
	{22,"Watchdog Tmout (ms)", B900W}
	{23,     "Watchdog Reset", B900W}
	{24,      "Watchdog type", B900W}
	{25,    "Modbus TCP mode", B900W}
}
