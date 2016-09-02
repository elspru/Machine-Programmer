
//
// void obtain_first_independentClause(
//    const uint16_t quiz_independentClause_list_size,
//    const v16us *restrict quiz_independentClause_list,
//    uint8_t *independentClause_size /*,
//                           uint8_t *newspaper_indexFinger, v16us *newspaper*/)
//                           {
//  //  agree(quiz_independentClause_list_size != 0,
//  //        (v16us){'O', 'F', 'S', ',', 'Q', 'S', 'L', 'S', '!', '=', '0'},
//  //        newspaper_indexFinger, newspaper);
//  //  agree(quiz_independentClause_list != NULL, (v16us) "OFS,WSLS!=N",
//  //        newspaper_indexFinger, newspaper);
//  //  agree(independentClause_size != NULL), (v16us) "OFS,SS!=N",
//  //      newspaper_indexFinger, newspaper;
//  *independentClause_size = 1;
//  //  agree(*independentClause_size < MAX_INDEPENDENTCLAUSE_TABLET, (v16us)
//  //  "OFS,SS<MSB",
//  //        newspaper_indexFinger, newspaper);
//}
// inline void play_quote(const v16us *tablet, const uint8_t tablet_indexFinger,
//                       const uint8_t tablet_size, uint16_t *quote_word,
//                       v8us *quote_fill) {
//  uint16_t word;
//  uint8_t quote_indexFinger = 0;
//  uint8_t quote_size;
//  // agree(tablet != NULL);
//  // agree(tablet_indexFinger < TABLET_LONG);
//  // agree(tablet_size < MAX_INDEPENDENTCLAUSE_TABLET);
//  // agree(quote_word != NULL);
//  // agree(quote_fill != NULL);
//  word = ((uint16_t *)tablet)[tablet_indexFinger];
//  // printf("quote quizing, word %04X\n", (uint)
//  (*tablet)[tablet_indexFinger]);
//  if ((word & CONSONANT_ONE_MASK) == QUOTED_REFERENTIAL) {
//    // then is quote
//    *quote_word = word;
//    // printf("quote detected %04X\n", (uint)word);
//    quote_size = (uint8_t)(
//        1 << (((*quote_word >> CONSONANT_ONE_THICK) & 7 /* 3 bit mask */) -
//        1));
//    // printf("quote_size %X \n", (uint)quote_size);
//    // printf("tablet_indexFinger %X \n", (uint)tablet_indexFinger);
//    // agree(quote_size < tablet_size * TABLET_LONG * WORD_THICK);
//    // printf("quote_fill ");
//    if (quote_size == 0) {
//      ((uint16_t *)quote_fill)[0] =
//          (uint16_t)(word >> QUOTED_LITERAL_INDEXFINGER);
//      // printf("%04X ", (uint)(*quote_fill)[0]);
//    }
//    for (quote_indexFinger = 0; quote_indexFinger < quote_size;
//         ++quote_indexFinger) {
//      ((uint16_t *)quote_fill)[quote_indexFinger] =
//          ((uint16_t *)tablet)[tablet_indexFinger + quote_indexFinger + 1];
//      // printf("%04X ", (uint)(*quote_fill)[quote_indexFinger]);
//    }
//    // printf("\n");
//  }
//}
//
// inline void burden_hook_list(const uint8_t tablet_size, const v16us *tablet,
//                             uint8_t *tablet_indexFinger, v4us *coded_name,
//                             v8us *hook_list) {
//  // agree(tablet_size != 0);
//  // agree(tablet != NULL);
//  // agree(coded_name != NULL);
//  // agree(hook_list != NULL);
//  // agree(tablet_indexFinger != NULL);
//  // agree(*tablet_indexFinger >= 1);
//  uint16_t indicator_list = 0;
//  uint8_t indicator = 0;
//  uint8_t tablet_number = 0;
//  uint8_t exit = FALSE;
//  uint16_t word = 0;
//  uint16_t quote_word = 0;
//  v8us quote_fill = {0, 0, 0, 0, 0, 0, 0, 0};
//  indicator_list = ((uint16_t *)tablet)[0];
//  indicator = (uint8_t)1 & indicator_list;
//  // printf("indicator %X\n", (uint) indicator);
//  // printf("indicator_list %X\n", (uint) indicator_list);
//  for (tablet_number = 0; tablet_number < tablet_size; ++tablet_number) {
//    for (; *tablet_indexFinger < TABLET_LONG; ++*tablet_indexFinger) {
//      // printf("BHL tablet_indexFinger %X\n", (uint)*tablet_indexFinger);
//      // if previous is indicated then quiz if is quote
//      if (((indicator_list & (1 << (*tablet_indexFinger - 1))) >>
//           (*tablet_indexFinger - 1)) == indicator) {
//        // printf("quote's word %X \n", (uint)tablet[0][*tablet_indexFinger]);
//        play_quote(tablet, *tablet_indexFinger, tablet_size, &quote_word,
//                   &quote_fill);
//      }
//      // if current is indicated then quiz if is case or
//      // verb
//      if (((indicator_list & (1 << *tablet_indexFinger)) >>
//           *tablet_indexFinger) == indicator) {
//        word = ((uint16_t **)&tablet)[tablet_number][*tablet_indexFinger];
//        // printf("BHL word %X\n", (uint)word);
//        switch (word) {
//        case ACCUSATIVE_CASE:
//          // printf("detected accusative case\n");
//          if (quote_word != 0) {
//            ((uint16_t *)coded_name)[ACCUSATIVE_INDEXFINGER] = quote_word;
//            // printf("coded_name ACC %04X%04X%04X%04X\n",
//            //       (uint)(*coded_name)[3], (uint)(*coded_name)[2],
//            //       (uint)(*coded_name)[1], (uint)(*coded_name)[0]);
//            hook_list[ACCUSATIVE_INDEXFINGER] = quote_fill;
//            // printf("ACC quote_fill %X\n", (uint)quote_fill[0]);
//            // printf("ACC hook_list %X\n",
//            // (uint)hook_list[ACCUSATIVE_INDEXFINGER][0]);
//            quote_word = 0;
//          }
//          break;
//        case DATIVE_CASE:
//          if (quote_word != 0) {
//            ((uint16_t *)coded_name)[DATIVE_INDEXFINGER] = quote_word;
//            hook_list[DATIVE_INDEXFINGER] = quote_fill;
//            quote_word = 0;
//          }
//          break;
//        case INSTRUMENTAL_CASE:
//          if (quote_word != 0) {
//            ((uint16_t *)coded_name)[INSTRUMENTAL_INDEXFINGER] = quote_word;
//            hook_list[INSTRUMENTAL_INDEXFINGER] = quote_fill;
//            quote_word = 0;
//          }
//          break;
//        default:
//          exit = TRUE;
//          break;
//        }
//      }
//      if (exit == TRUE)
//        break;
//    }
//    if (exit == TRUE)
//      break;
//  }
//}
//
// void obtain_import(const uint8_t independentClause_size,
//                   const v16us *restrict quiz_independentClause_list,
//                   uint8_t *brick_indexFinger, v4us *coded_name,
//                   v8us *hook_list) {
//  // uint16_t grammar_indicator = quiz_independentClause_list[0][0];
//  // uint8_t indicator = (uint8_t)(1 & grammar_indicator);
//  // uint8_t quiz_indexFinger = 0;
//  // uint8_t import_size = 0;
//  // agree(independentClause_size > 0);
//  // agree(quiz_independentClause_list != NULL);
//  // agree(hook_list != NULL);
//  burden_hook_list(independentClause_size, quiz_independentClause_list,
//                   brick_indexFinger, coded_name, hook_list);
//  // printf("OI hook_list: ");
//  // for (quiz_indexFinger = 0; quiz_indexFinger < HOOK_LIST_LONG;
//  // ++quiz_indexFinger) {
//  //  printf("%04X ", (uint)hook_list[quiz_indexFinger][0]);
//  //}
//  // printf("\n");
//  // for (brick_indexFinger = 0; brick_indexFinger < independentClause_size *
//  // TABLET_LONG;
//  //     ++brick_indexFinger) {
//  //  if (((grammar_indicator & (1 << brick_indexFinger)) >>
//  brick_indexFinger)
//  //  == indicator
//  //  &&
//  //      quiz_independentClause_list[0][brick_indexFinger] ==
//  CONDITIONAL_MOOD)
//  //      {
//  //    // import_size = (uint8_t)(brick_indexFinger + 1);
//  //    break;
//  //  }
//  //}
//}
//
// void obtain_export(const uint8_t independentClause_size,
//                   const v16us *restrict quiz_independentClause_list,
//                   uint8_t *brick_indexFinger, v4us *coded_name,
//                   v8us *hook_list) {
//  //  uint8_t brick_indexFinger = 0;
//  //  uint16_t grammar_indicator = quiz_independentClause_list[0][0];
//  //  uint8_t indicator = (uint8_t)(1 & grammar_indicator);
//  //  agree(independentClause_size > 0);
//  //  agree(quiz_independentClause_list != NULL);
//  //  agree(export_size != NULL);
//  // agree(independentClause_size > 0);
//  // agree(quiz_independentClause_list != NULL);
//  // agree(hook_list != NULL);
//  burden_hook_list(independentClause_size, quiz_independentClause_list,
//                   brick_indexFinger, coded_name, hook_list);
//  //  for (brick_indexFinger = import_size; brick_indexFinger <
//  //  independentClause_size *
//  //  TABLET_LONG;
//  //       ++brick_indexFinger) {
//  //    if (((grammar_indicator & (1 << brick_indexFinger)) >>
//  //    brick_indexFinger) == indicator
//  //    &&
//  //        quiz_independentClause_list[0][brick_indexFinger] == REALIS_MOOD)
//  {
//  //      *export_size = (uint8_t)(brick_indexFinger + 1);
//  //      break;
//  //    }
//  //  }
//}
//
// inline void play(const v4us coded_name, v8us *hook_list) {
//  void *accusative = NULL;
//  void *instrumental = NULL;
//  // void *dative =  NULL;
//  // agree(((uint16_t *)&coded_name)[VERB_INDEXFINGER] != 0);
//  // agree(hook_list != NULL);
//  // quizing hash key name
//  // printf("coded_name play %04X%04X%04X%04X\n",
//  //       (uint)((uint16_t *)&coded_name)[3], (uint)((uint16_t
//  //       *)&coded_name)[2],
//  //       (uint)((uint16_t *)&coded_name)[1],
//  //       (uint)((uint16_t *)&coded_name)[0]);
//  // switch (coded_name[ACCUSATIVE_INDEXFINGER]) {
//  // case UNSIGNED_CHAR_QUOTED:
//  //  accusative = (unsigned char *)&(hook_list[ACCUSATIVE_INDEXFINGER]);
//  //  break;
//  // case SIGNED_CHAR_QUOTED:
//  //  accusative = (char *)&(hook_list[ACCUSATIVE_INDEXFINGER]);
//  //  break;
//  // case SHORT_NUMBER_QUOTED:
//  //  accusative = (uint16_t *)&(hook_list[ACCUSATIVE_INDEXFINGER]);
//  //  break;
//  // case ERROR_BINARY:
//  //  break;
//  // default:
//  //  printf("unrecognized type %04X",
//  //  (uint)coded_name[ACCUSATIVE_INDEXFINGER]);
//  //  agree(0 != 0);
//  //  break;
//  //}
//  switch (((uint16_t *)&coded_name)[INSTRUMENTAL_INDEXFINGER]) {
//  case UNSIGNED_CHAR_QUOTED:
//    instrumental = (unsigned char *)&(hook_list[INSTRUMENTAL_INDEXFINGER]);
//    break;
//  case SIGNED_CHAR_QUOTED:
//    instrumental = (char *)&(hook_list[INSTRUMENTAL_INDEXFINGER]);
//    break;
//  case SHORT_NUMBER_QUOTED:
//    instrumental = (uint16_t *)&(hook_list[INSTRUMENTAL_INDEXFINGER]);
//    break;
//  case ERROR_BINARY:
//    break;
//  default:
//    // printf("unrecognized type %04X",
//    //       (uint)((uint16_t *)&coded_name)[ACCUSATIVE_INDEXFINGER]);
//    // agree(0 != 0);
//    break;
//  }
//  switch (*((uint64_t *)&coded_name)) {
//  case 0x6048009D00000000: /* say unsigned char* */
//    x6048009D00000000((unsigned char *)accusative);
//    break;
//  case 0x6048029D00000000: /* say signed char* */
//    x6048029D00000000((signed char *)accusative);
//    break;
//  case 0x4124000000000000: /* equal */
//    x4124000000000000((v8us *)hook_list);
//    break;
//  case 0x8006000000000000: /* different */
//    x8006000000000000((v8us *)hook_list);
//    break;
//  case 0xA130143D143D0000: /* not CCNOT */
//    xA130143D143D0000((uint16_t *)accusative, (uint16_t *)instrumental);
//    break;
//  case 0xC450143D143D0000: /* not CCNOT */
//    xC450143D143D0000((uint16_t *)accusative, (uint16_t *)instrumental);
//    break;
//  case 0x8006143D143D0000: /* not CCNOT */
//    x8006143D143D0000((uint16_t *)accusative, (uint16_t *)instrumental);
//    break;
//  default:
//    // printf(
//    //    "unrecognized coded_name %04X%04X%04X%04X\n",
//    //    (uint)((uint16_t *)&coded_name)[3], (uint)((uint16_t
//    //    *)&coded_name)[2],
//    //    (uint)((uint16_t *)&coded_name)[1], (uint)((uint16_t
//    //    *)&coded_name)[0]);
//    // agree(0 != 0);
//    break;
//  }
//}
// inline void play_independentClause(const uint8_t tablet_size,
//                                   const v16us *tablet, v4us *coded_name,
//                                   v8us *hook_list) {
//  /* go through coded independentClause,
//      loading quotes into temporary register,
//      append to case list,
//      when get to case, move to appropriate case register,
//      add to case counter, and append to case list,
//      when get to verb,
//      match to available functions by number of cases,
//      match to available functions by case list,
//      make 64bit hash key, ACC DAT INS verb,
//      with appropriate quotes filling in place of ACC DAT INS
//      or a 0 if there is none.
//      execute proper function.
//  */
//  uint16_t indicator_list = 0;
//  uint8_t indicator = 0;
//  uint8_t tablet_number = 0;
//  uint8_t tablet_indexFinger = 1;
//  uint8_t exit = FALSE;
//  uint16_t word = 0;
//  // agree(tablet_size != 0);
//  // agree(tablet != NULL);
//  // agree(coded_name != NULL);
//  // agree(hook_list != NULL);
//  indicator_list = ((uint16_t *)tablet)[0];
//  indicator = (uint8_t)1 & indicator_list;
//  // printf("indicator %X\n", (uint) indicator);
//  // printf("indicator_list %X\n", (uint) indicator_list);
//  burden_hook_list(tablet_size, tablet, &tablet_indexFinger, coded_name,
//                   hook_list);
//  // printf("coded_name burden %04X%04X%04X%04X\n", (uint)(*coded_name)[3],
//  //       (uint)(*coded_name)[2], (uint)(*coded_name)[1],
//  //       (uint)(*coded_name)[0]);
//  for (tablet_number = 0; tablet_number < tablet_size; ++tablet_number) {
//    for (; tablet_indexFinger < TABLET_LONG; ++tablet_indexFinger) {
//      // if current is indicated then quiz if is case or
//      // verb
//      if (((indicator_list & (1 << tablet_indexFinger)) >>
//           tablet_indexFinger) == indicator) {
//        word = ((uint16_t **)&tablet)[tablet_number][tablet_indexFinger];
//        // printf("word %X\n", (uint)word);
//        switch (word) {
//        case CONDITIONAL_MOOD:
//          word = ((uint16_t **)&tablet)[tablet_number][tablet_indexFinger -
//          1];
//          // printf("COND word %04X \n", (uint) word);
//          ((uint16_t *)coded_name)[VERB_INDEXFINGER] = word;
//          // printf("coded_name COND %04X%04X%04X%04X\n",
//          //       (uint)(*coded_name)[3], (uint)(*coded_name)[2],
//          //       (uint)(*coded_name)[1], (uint)(*coded_name)[0]);
//          play(*coded_name, hook_list);
//          // if dative is LIE_WORD then skip to next independentClause
//          if (((uint16_t **)&hook_list)[DATIVE_INDEXFINGER][0] == LIE_WORD) {
//            exit = TRUE;
//          } else {
//            ++tablet_indexFinger;
//            burden_hook_list(tablet_size, tablet, &tablet_indexFinger,
//                             coded_name, hook_list);
//            // printf("coded_name burden2 %04X%04X%04X%04X\n",
//            //       (uint)((uint16_t *)&coded_name)[3],
//            //       (uint)((uint16_t *)&coded_name)[2],
//            //       (uint)((uint16_t *)&coded_name)[1],
//            //       (uint)((uint16_t *)&coded_name)[0]);
//            // printf("tablet_indexFinger %X\n", (uint)tablet_indexFinger);
//            --tablet_indexFinger;
//          }
//          break;
//        case DEONTIC_MOOD:
//          // quizing verb
//          word = ((uint16_t **)tablet)[tablet_number][tablet_indexFinger - 1];
//          ((uint16_t *)&coded_name)[VERB_INDEXFINGER] = word;
//          // printf("coded_name DEO %04X%04X%04X%04X\n",
//          //       (uint)(*coded_name)[3], (uint)(*coded_name)[2],
//          //       (uint)(*coded_name)[1], (uint)(*coded_name)[0]);
//          // printf("realizing");
//          play((*coded_name), hook_list);
//          exit = TRUE;
//          break;
//        case REALIS_MOOD:
//          // quizing verb
//          word = ((uint16_t **)&tablet)[tablet_number][tablet_indexFinger -
//          1];
//          ((uint16_t *)coded_name)[VERB_INDEXFINGER] = word;
//          // printf("coded_name REAL %04X%04X%04X%04X\n",
//          //       (uint)((uint16_t *)&coded_name)[3],
//          //       (uint)((uint16_t *)&coded_name)[2],
//          //       (uint)((uint16_t *)&coded_name)[1],
//          //       (uint)((uint16_t *)&coded_name)[0]);
//          // printf("realizing");
//          play((*coded_name), hook_list);
//          exit = TRUE;
//          break;
//        case ERROR_BINARY:
//          // agree(ERROR_BINARY != ERROR_BINARY);
//          break;
//        default:
//          // printf("tablet_indexFinger %X\n", (uint)tablet_indexFinger);
//          // agree(1 == 0); // indicated wrong point
//          break;
//        }
//      }
//      if (exit == TRUE)
//        break;
//    }
//    if (indicator == 1 || exit == TRUE)
//      break;
//  }
//  // agree(indicator == 1); /* must finish properly */
//  // quizing grammtical-case list
//  // printf("\n");
//}
// inline void play_text(const uint16_t max_tablet_size, const v16us *tablet,
//                      v4us *coded_name, v8us *hook_list) {
//  /*
//    identify independentClause tablet,
//    then pass to independentClause_play,
//    and so on until reach end.
//  */
//  uint16_t tablet_indexFinger = 0;
//  // agree(tablet != NULL);
//  // agree(max_tablet_size > 0);
//  // agree(coded_name != NULL);
//  // agree(hook_list != NULL);
//  for (; tablet_indexFinger < max_tablet_size; ++tablet_indexFinger) {
//    play_independentClause((uint8_t)(max_tablet_size - tablet_indexFinger),
//                           &tablet[tablet_indexFinger], coded_name,
//                           hook_list);
//  }
//}
//
// void quiz_program(const uint16_t quiz_independentClause_list_size,
//                  const v16us *restrict quiz_independentClause_list,
//                  const uint16_t program_size, const v16us *restrict program,
//                  uint16_t *program_worth) {
//  /* algorithm:
//    for each quiz independentClause feed the program inputs,
//      and if the output is correct then add one to the program_worth.
//  */
//  uint16_t worth = 0;
//  uint16_t quiz_independentClause_indexFinger;
//  uint8_t independentClause_size = 0;
//  v4us coded_name = {0, 0, 0, 0};
//  // uint8_t import_size = 0;
//  // uint8_t export_size = 0;
//  // uint8_t quiz_indexFinger = 0;
//  uint8_t brick_indexFinger = 1;
//  uint8_t list_indexFinger = 0;
//  v8us hook_list[HOOK_LIST_LONG] = {0};
//  v8us export_hook_list[HOOK_LIST_LONG] = {0};
//  // memset(hook_list, 0, HOOK_LIST_LONG * HOOK_LIST_THICK * WORD_THICK);
//  // memset(export_hook_list, 0, HOOK_LIST_LONG * HOOK_LIST_THICK *
//  WORD_THICK);
//  //  agree(quiz_independentClause_list_size > 0);
//  //  agree(quiz_independentClause_list != NULL);
//  //  agree(program_size > 0);
//  //  agree(program != NULL);
//  //  agree(program_worth != NULL);
//  for (quiz_independentClause_indexFinger = 0;
//       quiz_independentClause_indexFinger < quiz_independentClause_list_size;
//       ++quiz_independentClause_indexFinger) {
//    brick_indexFinger = 1;
//    // obtain_first_independentClause(); // for multi brick independentClauses
//    // printf("ITERATION %X\n", quiz_independentClause_indexFinger);
//    // memset((char *)&coded_name, 0, 8);
//    // memset(hook_list, 0, V8US_LONG * HOOK_LIST_LONG);
//    // memset(export_hook_list, 0, V8US_LONG * HOOK_LIST_LONG);
//    obtain_first_independentClause(
//        (uint16_t)(quiz_independentClause_list_size -
//                   quiz_independentClause_indexFinger),
//        quiz_independentClause_list + quiz_independentClause_indexFinger,
//        &independentClause_size);
//    // obtain_import
//    obtain_import(independentClause_size,
//                  quiz_independentClause_list +
//                      quiz_independentClause_indexFinger,
//                  &brick_indexFinger, &coded_name, hook_list);
//    // printf("hook_list: ");
//    // for (quiz_indexFinger = 0; quiz_indexFinger < HOOK_LIST_LONG;
//    // ++quiz_indexFinger) {
//    //  printf("%04X ", (uint)hook_list[quiz_indexFinger][0]);
//    //}
//    // printf("\n");
//    for (list_indexFinger = 0; list_indexFinger < HOOK_LIST_LONG;
//         ++list_indexFinger) {
//      export_hook_list[list_indexFinger] = hook_list[list_indexFinger];
//    }
//    // copy_randomAccessMemory((char *)&export_hook_list, (char *)&hook_list,
//    //       V8US_LONG * HOOK_LIST_LONG);
//    // obtain_export
//    // printf("pre export hook_list: ");
//    // for (quiz_indexFinger = 0; quiz_indexFinger < HOOK_LIST_LONG;
//    // ++quiz_indexFinger) {
//    //  printf("%04X ", (uint)export_hook_list[quiz_indexFinger][0]);
//    //}
//    // printf("\n");
//    ++brick_indexFinger;
//    // printf("brick_indexFinger %X\n", (uint)brick_indexFinger);
//    obtain_export(independentClause_size,
//                  quiz_independentClause_list +
//                      quiz_independentClause_indexFinger,
//                  &brick_indexFinger, &coded_name, export_hook_list);
//    // printf("export hook_list: ");
//    // for (quiz_indexFinger = 0; quiz_indexFinger < HOOK_LIST_LONG;
//    // ++quiz_indexFinger) {
//    //  printf("%04X ", (uint)export_hook_list[quiz_indexFinger][0]);
//    //}
//    // printf("\n");
//    // printf("coded_name burden3 %04X%04X%04X%04X\n",
//    // (uint)(coded_name)[3],
//    //        (uint)(coded_name)[2], (uint)(coded_name)[1],
//    //        (uint)(coded_name)[0]);
//    // play_program
//    play_text(program_size, program, &coded_name, hook_list);
//    // printf("hook_list-after: ");
//    // for (quiz_indexFinger = 0; quiz_indexFinger < HOOK_LIST_LONG;
//    // ++quiz_indexFinger) {
//    //  printf("%04X ", (uint)hook_list[quiz_indexFinger][0]);
//    //}
//    // printf("\n");
//    if (comparison_randomAccessMemory((char *)&export_hook_list,
//                                      (char *)&hook_list,
//                                      V8US_LONG * HOOK_LIST_LONG) == 0) {
//      ++worth;
//    }
//    // compare program_export to quiz_export
//  }
//  // printf("worth: %X\n", (uint)worth);
//  *program_worth = worth;
//}
//
// void quiz_population(const uint16_t quiz_independentClause_list_size,
//                     const v16us *restrict quiz_independentClause_list,
//                     const uint16_t program_size, const uint8_t
//                     population_size,
//                     const v16us *restrict population, uint8_t *champion,
//                     uint16_t *champion_worth) {
//  uint16_t program_worth = 0;
//  uint8_t program_number = 0;
//  //  agree(quiz_independentClause_list_size > 0);
//  //  agree(quiz_independentClause_list != NULL);
//  //  agree(program_size > 0);
//  // agree(population_size > 0);
//  // agree(population != NULL);
//  // agree(champion != NULL);
//  // agree(champion_worth != NULL);
//  for (; program_number < population_size; ++program_number) {
//    program_worth = 0;
//    quiz_program(quiz_independentClause_list_size,
//    quiz_independentClause_list,
//                 program_size, &population[program_number], &program_worth);
//    if (program_worth > *champion_worth) {
//      *champion = program_number;
//      *champion_worth = program_worth;
//    }
//  }
//}
