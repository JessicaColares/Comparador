	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Automato */

	case 3: // STATE 1
		;
		now.a = trpt->bup.oval;
		;
		goto R999;

	case 4: // STATE 2
		;
		now.b = trpt->bup.oval;
		;
		goto R999;

	case 5: // STATE 3
		;
		now.resultado = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 7: // STATE 5
		;
		now.resultado = trpt->bup.oval;
		;
		goto R999;

	case 8: // STATE 6
		;
		now.a = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		;
		
	case 11: // STATE 14
		;
		p_restor(II);
		;
		;
		goto R999;
	}

