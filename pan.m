#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC Automato */
	case 3: // STATE 1 - resultados_automatos/spin_modelo_14.pml:8 - [a = 14] (0:0:1 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.oval = now.a;
		now.a = 14;
#ifdef VAR_RANGES
		logval("a", now.a);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - resultados_automatos/spin_modelo_14.pml:9 - [b = (14+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = now.b;
		now.b = (14+1);
#ifdef VAR_RANGES
		logval("b", now.b);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - resultados_automatos/spin_modelo_14.pml:10 - [resultado = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.oval = now.resultado;
		now.resultado = 0;
#ifdef VAR_RANGES
		logval("resultado", now.resultado);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - resultados_automatos/spin_modelo_14.pml:14 - [((a<b))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][4] = 1;
		if (!((now.a<now.b)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 5 - resultados_automatos/spin_modelo_14.pml:15 - [resultado = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[0][5] = 1;
		(trpt+1)->bup.oval = now.resultado;
		now.resultado = 1;
#ifdef VAR_RANGES
		logval("resultado", now.resultado);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 8: // STATE 6 - resultados_automatos/spin_modelo_14.pml:16 - [a = (a+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][6] = 1;
		(trpt+1)->bup.oval = now.a;
		now.a = (now.a+1);
#ifdef VAR_RANGES
		logval("a", now.a);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 12 - resultados_automatos/spin_modelo_14.pml:21 - [assert(((resultado==0)||(resultado==1)))] (0:0:0 - 3)
		IfNotBlocked
		reached[0][12] = 1;
		spin_assert(((now.resultado==0)||(now.resultado==1)), "((resultado==0)||(resultado==1))", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 13 - resultados_automatos/spin_modelo_14.pml:22 - [printf('Autômato %d: resultado = %d\\n',14,resultado)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		Printf("Autômato %d: resultado = %d\n", 14, now.resultado);
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 14 - resultados_automatos/spin_modelo_14.pml:23 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][14] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

