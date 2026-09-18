     ** HELLO WORLD in the IFS Example:
     **  (From Chapter 1)
     **
     **  To compile:
     **     CRTBNDRPG IFS_5 SRCFILE(tvrelwaeco/QRPGLESRC) DBGVIEW(*LIST)
     **

     H DFTACTGRP(*NO) ACTGRP(*NEW)


     ** API call to open a stream file
     **
     D open            PR            10I 0 extproc('open')
     D   path                          *   value options(*string)
     D   oflag                       10I 0 value
     D   mode                        10U 0 value options(*nopass)
     D   codepage                    10U 0 value options(*nopass)

     D O_RDONLY        C                   1
     D*                                            Writing Only
     D O_WRONLY        C                   2
     D*                                            Reading & Writing
     D O_RDWR          C                   4
     D*                                            Create File if not exist
     D O_CREAT         C                   8
     D*                                            Exclusively create
     D O_EXCL          C                   16
     D*                                            Truncate File to 0 bytes
     D O_TRUNC         C                   64
     D*                                            Append to File
     D O_APPEND        C                   256
     D*                                            Convert text by code-page
     D O_CODEPAGE      C                   8388608
     D*                                            Open in text-mode
     D O_TEXTDATA      C                   16777216

     D**********************************************************************
     D*      Mode Flags.
     D*         basically, the mode parm of open(), creat(), chmod(),etc
     D*         uses 9 least significant bits to determine the
     D*         file's mode. (peoples access rights to the file)
     D*
     D*           user:       owner    group    other
     D*           access:     R W X    R W X    R W X
     D*           bit:        8 7 6    5 4 3    2 1 0
     D*
     D* (This is accomplished by adding the flags below to get the mode)
     D**********************************************************************
     D*                                         owner authority
     D S_IRUSR         C                   256
     D S_IWUSR         C                   128
     D S_IXUSR         C                   64
     D S_IRWXU         C                   448
     D*                                         group authority
     D S_IRGRP         C                   32
     D S_IWGRP         C                   16
     D S_IXGRP         C                   8
     D S_IRWXG         C                   56
     D*                                         other people
     D S_IROTH         C                   4
     D S_IWOTH         C                   2
     D S_IXOTH         C                   1
     D S_IRWXO         C                   7

     ** S_IRUSR+S_IWUSR+S_IRGRP

     D RW              C                   6
     D R               C                   4
     D OWNER           C                   64
     D GROUP           C                   8

     ** API call to write data to a stream file
     **
     D write           PR            10I 0 extproc('write')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value

     D read            PR            10I 0 extproc('read')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value


     ** API call to close a stream file
     **
     D close           PR            10I 0 extproc('close')
     D   fildes                      10I 0 value


     D fd              S             10I 0
     D data            S            132A
     D msg             S             52A
     D flags           S             10U 0
     D mode            S             10U 0
     D path            s           1024A

     C* Create an empty file called 'helloworld':

     c                   eval      path = '/SALESCOMPANY/IFS_5/IFS_5'
     c***                eval      fd = open('IFS_5':
     c***                                   O_CREAT+O_TRUNC+O_WRONLY:
     c***                                   RW*OWNER + RW*GROUP + R )

     c                   eval      flags = O_WRONLY + O_CREAT + O_TRUNC

     c                   eval      mode =  S_IRUSR + S_IWUSR
     c                                   + S_IRGRP

     c                   eval      fd = open(%trimr(path): flags: mode)
     c                   if        fd < 0
     c                   eval      Msg = 'open failed!'
     c                   dsply                   msg
     c                   eval      *inlr = *on
     c                   return
     c                   endif

     C* Write 'Hello World' to the file:
     c                   eval      data = 'Hello World!'
     c                   callp     write(fd: %addr(data): %size(data))
     c                   eval      data = 'second      '
     c                   callp     write(fd: %addr(data): %size(data))

     C* Close the file:
     c                   callp     close(fd)

     c                   eval      *inlr = *on

