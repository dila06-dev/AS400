     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Generisches FTp aufrufen                                *
     F************************************************************

     /************************************************************************/
     /* File: FTPCPP.QRPGLESRC Precompiler for generic Compile of objects    */
     /* Copyright (C) 2002  Dieter Bender  <db@bender-dv.de>                 */
     /*                                                                      */
     /* This program is free software; you can redistribute it and/or modify */
     /* it under the terms of the GNU General Public License as published by */
     /* the Free Software Foundation.                                        */
     /*                                                                      */
     /* This program is distributed in the hope that it will be useful,      */
     /* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
     /* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
     /* GNU General Public License for more details.                         */
     /*                                                                      */
     /* You should have received a copy of the GNU General Public License    */
     /* along with this program; if not, write to the Free Software          */
     /* Foundation, Inc., 59 Temple Place,                                   */
     /* Suite 330, Boston, MA  02111-1307   USA                              */
     /* You might find a version at http://www.gnu.org                       */
     /************************************************************************/
     H copyright('Dieter Bender 03/2002 <db@bender-dv.de>')

     FQFTPSRC   UF A E             DISK    USROPN
     F                                     RENAME(QFTPSRC:QFTPSRCR)

     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'

     /*--- Constants
     D TRUE            C                   *ON
     D FALSE           C                   *OFF

     /*--- Main Interface
     D  Subsidiary     S              2A
     D  FtpUser        S             10A
     D  Password       S             10A
     D  FtpMode        S             10A
     D  NameFormat     S              1A
     D  Ftpcommand     S              4A
     D  FromDir        S             80A
     D  Fromfile       S             32A
     D  ToDir          S             80A
     D  Tofile         S             32A
     D  delete_after   S              1A
     D  wildcardKZ     S              1A

     C     *entry        plist
     C                   parm                    Subsidiary
     C                   parm                    FtpUser
     C                   parm                    Password
     c                   parm                    FtpMode
     c                   parm                    NameFormat
     C                   parm                    ftpcommand
     C                   parm                    FromDir
     C                   parm                    Fromfile
     C                   parm                    ToDir
     C                   parm                    Tofile
     C                   parm                    delete_after


     C                   open      QFTPSRC

     C                   eval      SRCDTA = FtpUser + ' ' + Password
     C                   write     QFTPSRCR
     C                   eval      SRCDTA = FtpMode
     C                   write     QFTPSRCR
     C                   eval      SRCDTA = 'NAMEFMT ' + NameFormat
     C                   write     QFTPSRCR
     C                   eval      SRCDTA = 'cd ' + %trim(fromdir)
     C                   write     QFTPSRCR
     C                   eval      SRCDTA = 'lcd ' + %trim(todir)
     C                   write     QFTPSRCR
     C                   eval      FromFile = %XLATE(lo:up:FromFile)
     C                   eval      ToFile = %XLATE(lo:up:ToFile)
     C                   eval      SRCDTA = %trim(ftpcommand) + ' ' +
     C                                      %trim(FromFile) + ' ' +
     C                                      %trim(ToFile)
     C                   write     QFTPSRCR
     C                   IF        delete_after = 'Y' or delete_after = 'y' or
     C                             delete_after = 'j' or delete_after = 'J' or
     C                             delete_after = '1'
     c                   move      fromfile      wildcardKZ
     c                   evalr     wildcardKZ = %trim(FromFile)
     c                   if        wildcardKZ = '*'
     C                   eval      SRCDTA = 'MDELETE ' + %trim(FromFile)
     C                   ELSE
     C                   eval      SRCDTA = 'DELETE ' + %trim(FromFile)
     C                   ENDIF
     C                   write     QFTPSRCR
     C                   ENDIF
     C                   eval      SRCDTA = 'quit'
     C                   write     QFTPSRCR
     C                   close     QFTPSRC
     c
     C                   move      *on           *inlr
