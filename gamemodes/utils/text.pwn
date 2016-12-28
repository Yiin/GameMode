

stock LithuanizeString(num, One[], Two[], Ten[], ReturnNumber = false) {
	new ret[100];

	if(ReturnNumber) {
		format(ret, _, "%i ", num);
	}
	if (num % 10 > 1 && (num > 20 || num < 10))
		strcat(ret, Ten);
	else if (num % 10 == 0)
		strcat(ret, Two);
	else if (num % 10 == 1)
		strcat(ret, One);

	return ret;
}