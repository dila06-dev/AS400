     Hdatfmt(*eur)
     D edtwdf          C                   CONST('+ .   .   . 0 ,     ')
     D num15o          S              1    DIM(15)
     D num15n          S              1    dim(16)
     D num21o          S              1    DIM(21)
     D num21n          S              1    dim(21)
     D num15v          S              1    dim(10)
     D num15d          S              1    dim(5)
     D alp21           S              1    dim(21)
     D alp21n          S              1    dim(21)
     D ae              S              1    dim(63)
     Dsl               s             10u 0
     D                 DS
     Dnummerg                  1     15
     Dnummerv                  1     10
     Dnummerd                 11     15
     D                 DS                  inz
     Ddecnum                   1     15  0
     D                 DS                  inz
     Dmapdat                   1      7  0
     Dmapcen                   1      1  0
     Dmapjhr                   2      3  0
     Dmapmon                   4      5  0
     Dmaptag                   6      7  0
     D                 DS
     Deuro                     1     10
     Deurotag                  1      2  0
     Deuromon                  4      5  0
     Deurocen                  7      8  0
     Deurojhr                  9     10  0
      *
     C     *entry        plist
     C                   parm                    alpha            21
     C                   parm                    nummer           15 5
     C                   parm                    anzdec            1 0
     C                   parm                    format            1
     c                   parm                    aufrnd            1
     c                   parm                    atrind            2 0
     c                   parm                    maxlng            2 0
     c                   parm                    rtnlng            2 0
     c     'x':'X'       xlate     format        format
     c                   if        format = 'X'
     c                   goto      #end
     c                   end
     c                   movel     *blank        alpha
     c                   move      '00.00.0000'  euro
     c                   if        atrind < 1 or atrind > 63
     c                   z-add     1             atrind
     c                   end
     c                   if        maxlng < 2 or maxlng > 21
     c                   z-add     21            maxlng
     c                   end
     c     'x':'X'       xlate     format        format
     c                   if        format = 'X'
     c                   goto      #end
     c                   end
     c     'j':'J'       xlate     format        format
     c     'm':'M'       xlate     format        format
     c                   if        format <> 'J' and format <> 'M'
     c                   movel     'N'           format
     c                   end
     c                   if        aufrnd <> 'j' and aufrnd <> 'J'
     c                   movel     'N'           aufrnd
     c                   end
     c                   move      *blank        ae
     c                   movel     *blank        §§atr            63
     c                   call      '#MODATR'                            99
     c                   parm                    §§atr
     c                   movea     §§atr         ae
     c                   movel     *off          *in65
     c                   z-add     0             rtnlng
     c                   z-add     0             faktor           3010
     c                   z-add     0             faknum           30 0
     c*    alpha         ifeq      *blank
     c*    nummer        andeq     0
     c*                  goto      #end
     c*                  end
     c*    nummer        ifeq      0
     c*                  exsr      #alpha
     c*                  goto      #end
     c*                  end
     c     format        ifeq      'M'
     c                   exsr      #md0000
     c                   goto      #end
     c                   end
     c                   movel     *on           *in65
     c                   exsr      #numrnd
     c     format        ifeq      'N'
     c                   exsr      #numfm
     c                   goto      #endnum
     c                   end
     c                   movel     *blank        fnummer          20
     c                   movel     *blank        unummer          21
     c                   eval      fnummer = %editw(nummer:edtwdf)
     c                   eval      fnummer=%triml(fnummer)
     c     nummer        iflt      0
     c                   movel(p)  '-'           unummer
     c                   eval      %subst(unummer:2:20)=fnummer
     c                   else
     c                   movel(p)  fnummer       unummer
     c                   end
     c                   exsr      #numfmt
     c                   movel(p)  unummer       alpha
     c                   exsr      #komfmt
     c                   movel(p)  unummer       alpha
     c     #endnum       tag
     c     ' '           checkr    alpha         sl
     c     sl            ifle      0
     c                   z-add     21            rtnlng
     c                   else
     c                   z-add     sl            rtnlng
     c                   end
     c     *in65         ifeq      *off
     c                   goto      #end
     c                   end
     c                   movel     *blank        xalpha           22
     c                   movea     ae(atrind)    xatr              1
     c                   z-add     rtnlng        ol                2 0
     c                   z-add     maxlng        wl                2 0
     c     wl            sub       ol            rl                2 0
     c     rl            iflt      1
     c                   eval      %subst(xalpha:1:ol)=alpha
     c                   movea     ae(11)        xatr
     c                   z-add     11            atrind
     c                   add       1             rtnlng
     c                   goto      #nulnum
     c                   end
     c                   add       1             rl
     c                   eval      %subst(xalpha:rl:ol)=%subst(alpha:1:ol)
     c     #nulnum       tag
     c                   movel     xatr          xalpha
     c                   movel     *blank        alpha
     c                   movel     xalpha        alpha
     c                   movea     alpha         alp21
     c                   movea     ae(atrind)    xatr              1
     c                   movea     xatr          alp21(1)
     c                   movea     alp21         alpha
     c     #end          tag
     c     format        ifeq      'X'
     c                   movel     *on           *inlr
     c                   else
     c                   return
     c                   end
     c     #numrnd       begsr
     c                   movel     *off          *in60
     c     anzdec        ifge      5
     c                   goto      #numrndx
     c                   end
     c                   move      nummer        nummerg
     c                   move      nummerg       decnum
     c     anzdec        ifeq      0
     c                   eval      faktor = 1
     c                   else
     c                   eval      faktor = 1 * (10 ** anzdec)
     c                   end
     c     nummer        mult(h)   faktor        faknum
     c     faknum        div       faktor        nummer
     c     #numrndx      endsr
     c     #komfmt       begsr
     c                   movel     *blank        unummer
     c                   movel(p)  alpha         unummer
     c     nummer        iflt      0
     c                   eval      nummer = nummer * -1
     c                   end
     c                   move      nummer        nummerg
     c     ',':1         scan      unummer       kp                       78
     c                   z-add     0             rs                2 0
     c                   z-add     0             bg                2 0
     c                   eval      rs = 21 - kp
     c                   eval      bg = kp + 1
     c                   eval      %subst(unummer:bg:rs)=nummerd
     c     anzdec        ifeq      0
     c                   eval      %subst(unummer:kp:1) = ' '
     c                   move      *blank        nummerd
     c                   eval      %subst(unummer:bg:rs)=nummerd
     c                   movel(p)  unummer       alpha
     c                   goto      #komfmtx
     c                   end
     c     anzdec        ifgt      5
     c                   z-add     5             anzdec
     c                   end
     c                   eval      bg = kp + anzdec
     c     bg            ifgt      21
     c                   goto      #komfmtx
     c                   end
     c                   eval      rs = 21 - bg
     c                   eval      bg = bg + 1
     c                   move      *blank        alpha
     c                   eval      %subst(unummer:bg:rs) = %subst(alpha:1:rs)
     c     #komfmtx      endsr
     c     #numfmt       begsr
      *
     c     ' ':'0'       xlate     unummer       unummer
     c                   movea     unummer       num21o
     c                   movel     *off          *in98
     c                   z-add     22            p                 2 0
     c                   z-add     21            n
     c                   do        21            o
     c                   eval      p = p -1
     c                   movea     num21o(p)     zxn
     c     zxn           ifne      '0'
     c                   move      *on           *in98
     c                   end
     c     *in98         ifeq      *off
     c                   movel     ' '           zxn
     c                   movea     zxn           num21o(p)
     c                   end
     c                   enddo
     c                   movea     num21o        unummer
     c                   endsr
      *
     c     #numfm        begsr
      *
     c                   move      *blank        znummer          15
     c                   move      *blank        nnummer          16
     c                   move      *blank        num15o
     c                   move      *blank        num15n
     c                   z-add     0             o                 2 0
     c                   z-add     0             n                 2 0
     c     nummer        iflt      0
     c                   movea     '-'           num15n(1)
     c                   z-add     1             n
     c                   eval      nummer = nummer * -1
     c                   end
     c                   move      nummer        nummerg
     c                   move      *blank        numdc5            5
     c                   z-add     0             dl                1 0
     c                   z-add     0             dp                1 0
     c     anzdec        iflt      5
     c                   eval      dp = anzdec +1
     c                   eval      dl = 5 - anzdec
     c                   eval      %subst(nummerd:dp:dl)=%subst(numdc5:1:dl)
     c                   end
     c                   move      nummerg       znummer          15
     c                   movel     *off          *in98
     c                   movea     znummer       num15o
     c                   do        15            o
     c                   movea     num15o(o)     zxn               1
     c     zxn           ifne      '0'
     c                   movel     *on           *in98
     c                   end
     c     *in98         ifeq      *on
     c                   add       1             n
     c                   movea     zxn           num15n(n)
     c                   end
     c                   enddo
     c                   movea     num15n        nnummer
     c                   movel(p)  nnummer       alpha
     c                   endsr
      *
     c     #alpha        begsr
      *
     c                   move      *blank        alp21n
     c                   move      *blank        alp21
     c                   move      *blank        alphax           21
     c                   move      *all'0'       num15v
     c                   move      *all'0'       num15d
     c                   eval      alpha = %triml(alpha)
     c     ' '           checkr    alpha         sl
     c                   eval      bg = sl -1
     c                   if        %subst(alpha:sl) = '-' or
     c                             %subst(alpha:sl) = '+'
     c                   eval      zxn=%subst(alpha:sl:1)
     c                   eval      %subst(alphax:1:1)=zxn
     c                   eval      %subst(alphax:2:bg)=%subst(alpha:1:bg)
     c                   eval      %subst(alphax:sl:1)='0'
     c                   movel     alphax        alpha
     c                   end
      *
     c                   movea     alpha         alp21
     c                   z-add     0             o
     c                   z-add     0             n
     c                   do        21            o
     c                   if        o > 1 and
     c                             alp21(o) <> '+' and alp21(o) <> '-'
     c                   if        alp21(o) <> ' ' and alp21(o) <> '.' and
     c                             alp21(o) <> ',' and
     c                             (alp21(o) < '0' or alp21(o) > '9')
     c                   movea     '0'           alp21(o)
     c                   endif
     c                   endif
     c                   enddo
      *
     c                   movea     alp21         alpha
      *
     c                   movea     alpha         alp21
     c                   z-add     0             o
     c                   z-add     0             n
     c                   movel     *off          *in98
     c                   do        21            o
     c                   if        alp21(o) <> ' ' and alp21(o) <> '.' and
     c                             alp21(o) <> ',' and alp21(o) <> '+' and
     c                             alp21(o) <> '-' and
     c                             (alp21(o) < '0' or alp21(o) > '9')
     c                   move      '0'           zxn
     c                   movea     zxn           alp21(o)
     c                   endif
     c                   enddo
      *
     c                   movea     alp21         alpha
     c                   movea     alpha         alp21
     c                   move      *blank        alp21n
     c                   z-add     0             o
     c                   z-add     0             n
     c                   movel     *off          *in98
     c                   do        21            o
     c                   if        o=1 and (alp21(o) = '+' or alp21(o) = '-')
     c                   add       1             n
     c                   movea     alp21(o)      zxn
     c                   movea     zxn           alp21n(1)
     c                   endif
     c                   if        alp21(o) = '.' or alp21(o) = ',' or
     c                             (alp21(o) >='0' and alp21(o) <= '9')
     c                   movea     alp21(o)      zxn
     c                   movea     zxn           alp21n(o)
     c                   endif
     c                   enddo
      *
     c                   movea     alp21n        alpha
      *
     c                   movea     alpha         alp21
     c                   z-add     0             o
     c                   z-add     0             n
     c                   movel     *off          *in98
     c                   do        21            o
     c                   if        alp21(o) <> ' ' and alp21(o) <> '.' and
     c                             alp21(o) <> ',' and alp21(o) <> '+' and
     c                             alp21(o) <> '-' and
     c                             (alp21(o) < '0' or alp21(o) > '9')
     c                   move      '0'           zxn
     c                   movea     zxn           alp21(o)
     c                   endif
     c                   enddo
      *
     c                   movea     alp21         alpha
      *
     c                   movea     alpha         alp21n
     c                   move      *blank        alp21
     c                   z-add     0             o
     c                   z-add     0             n
     c                   movel     *off          *in98
     c                   do        21            o
     c                   if        alp21n(o) = '+' or alp21n(o) ='-' or
     c                             alp21n(o) = '.' or alp21n(o) = ',' or
     c                             (alp21n(o) >= '0' and alp21n(o) <= '9')
     c                   add       1             n
     c                   movea     alp21n(o)     zxn
     c                   movea     zxn           alp21(n)
     c                   endif
     c                   enddo
      *
     c                   movea     alp21         alpha
     c                   movea     *blank        alp21n
      *
     c                   z-add     0             o
     c                   z-add     0             n
     c                   movel     *off          *in98
     c                   do        21            o
     c                   movea     alp21(o)      zxn
     c                   if        o = 1 and
     c                             (zxn = '-' or zxn = '+')
     c                   add       1             n
     c                   movea     zxn           alp21n(n)
     c                   endif
     c                   if        o > 1 and
     c                             (zxn >= '1' and zxn <= '9')
     c                   movel     *on           *in98
     c                   endif
     c                   if        *in98 = *on
     c                   add       1             n
     c                   movea     zxn           alp21n(n)
     c                   endif
     c                   enddo
      *
     c                   movea     alp21n        alpha
     c                   movea     alpha         alp21
      *
     c     ' '           checkr    alpha         sl
     c     ' ':'0'       xlate     alpha         alpha
     c                   movel     *blank        alphan           21
      *
     c                   z-add     0             o
     c                   movel     'N'           negativ           1
     c                   movel     'N'           vorzeichen        1
     c                   do        21            o
     c                   if        alp21(o) = '-'
     c                   movel     'J'           negativ
     c                   movel     'J'           vorzeichen
     c                   leave
     c                   endif
     c                   if        alp21(o) = '+'
     c                   movel     'J'           vorzeichen
     c                   leave
     c                   endif
     c                   enddo
      *
     c     vorzeichen    ifeq      'J'
     c     sl            andle     1
     c                   z-add     0             nummer
     c                   goto      #alphax
     c                   end
      *
     c                   movel     'N'           komma             1
      *
     c                   z-add     0             k                 2 0
     c                   z-add     0             o
     c                   do        21            o
     c                   if        alp21(o) = ','
     c                   movel     'J'           komma
     c                   leave
     c                   end
     c                   enddo
      *
     c     komma         ifeq      'J'
     c     sl            andle     1
     c                   z-add     0             nummer
     c                   goto      #alphax
     c                   end
      *
     c                   z-add     0             anzv              2 0
     c                   z-add     0             o
     c                   do        21            o
     c                   if        (alp21(o) < '0' or alp21(o) > '9')
     c                             and alp21(o)<> ' '
     c                   add       1             anzv
     c                   endif
     c                   enddo
      *
     c     anzv          ifge      sl
     c                   z-add     0             nummer
     c                   goto      #alphax
     c                   end
      *
     c                   z-add     0             k                 2 0
     c                   z-add     0             o
     c                   do        21            o
     c                   if        alp21(o) = ','
     c                   eval      k = sl - o
     c                   leave
     c                   end
     c                   enddo
      *
     c     k             ifgt      5
     c                   z-add     5             k
     c                   end
      *
     c                   move      *blank        alp21n
     c                   z-add     0             o
     c                   z-add     0             n
      *
     c                   do        21            o
     c                   if        alp21(o) >='0' and alp21(o)<='9'
     c                   movea     alp21(o)      zxn
     c                   add       1             n
     c                   movea     zxn           alp21n(n)
     c                   endif
     c                   enddo
      *
     c     k             iflt      0
     c                   z-add     0             k
     c                   end
      *
     c     anzdec        ifle      0
     c                   z-add     0             anzdec
     c                   else
     c     anzdec        ifgt      5
     c                   z-add     5             anzdec
     c                   end
     c                   end
      *
     c     k             ifeq      0
     c                   z-add     anzdec        k
     c                   end
      *
     c                   movea     alp21n        alp21z           21
     c                   movel     alp21z        alp15z           15
      *
     c     k             ifeq      0
     c                   movel     alp21z        alp15z           15
     c     ' ':'0'       xlate     alp15z        alp15z
     c                   move      alp15z        nummer
     c                   goto      #alphax
     c                   end
      *
     c     ' '           checkr    alp21z        sl
      *
     c     sl            ifeq      0
     c                   z-add     0             nummer
     c                   goto      #alphax
     c                   end
      *
     c     sl            iflt      2
     c                   if        %subst(alp21z:1:1)='0'
     c                   z-add     0             nummer
     c                   goto      #alphax
     c                   end
     c                   end
      *
     c                   move      *all'0'       num15v
     c                   move      *all'0'       num15d
      *
     c     sl            ifgt      15
     c                   z-add     15            sl
     c                   end
      *
     c     k             ifeq      0
     c     sl            andge     15
     c                   move      alp15z        nummer
     c                   goto      #alphax
     c                   end
      *
     c                   movea     alp21n        alp21z
     c     ' ':'0'       xlate     alp21z        alp21z
     c                   movea     alp21z        alp21n
      *
     c                   z-add     0             kp                2 0
     c                   z-add     0             bg                2 0
     c     sl            sub       k             vor               2 0
     c                   eval      kp = vor + 1
      *
     c                   if        (sl - k) >= 10
     c                   movea     alp21n        num15v
     c                   movea     alp21n(11)    num15d
     c                   movea     num15v        nummerv
     c                   movea     num15d        nummerd
     c     ' ':'0'       xlate     nummerv       nummerv
     c     ' ':'0'       xlate     nummerd       nummerd
     c                   move      nummerg       nummer
     c                   goto      #alphax
     c                   end
      *
     c                   eval      bg = 11 - vor
     c                   movea     alp21n        num15v(bg)
     c                   movea     alp21n(kp)    num15d
     c                   movea     num15v        nummerv
     c                   movea     num15d        nummerd
     c     ' ':'0'       xlate     nummerv       nummerv
     c     ' ':'0'       xlate     nummerd       nummerd
     c                   move      nummerg       nummer
      *
     c     #alphax       tag
     c     negativ       ifeq      'J'
     c                   eval      nummer = nummer * -1
     c                   end
      *
     c                   exsr      #numrnd
      *
     c                   endsr
      *
     c     #md0000       begsr
      *
     c                   z-add     11            rtnlng
     c     nummer        ifle      0
     c                   z-add     0             nummer
     c                   end
     c                   z-add     nummer        mapdat
     c     nummer        ifeq      0
     c                   movea     ae(atrind)    xatr
     c                   movel     xatr          alpha
     c                   eval      %subst(alpha:2:10)=euro
     c                   goto      #md0000x
     c                   end
     c                   move      maptag        eurotag
     c                   move      mapmon        euromon
     c                   move      mapjhr        eurojhr
     c                   eval      eurocen = mapcen + 19
     c                   test(D)                 euro                   99
     c     *in99         ifeq      *off
     c                   movea     ae(atrind)    xatr
     c                   else
     c                   movea     ae(11)        xatr
     c                   end
     c                   movel     xatr          alpha
     c                   eval      %subst(alpha:2:10)=euro
     c     #md0000x      endsr
