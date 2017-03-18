unit lex;      {database moderating unit}
interface
uses crt, graph;
type multitrans=array[1..10] of string;  {database structure}
     def=record
         word:string[20];
         trans:multitrans;
         end;
     vocabulary=file of def;

     voc=object
     main_file:vocabulary;
     password:string;
procedure convert_from_txt(var size:longint; var fname:string);
procedure start(var flag:boolean; var size:longint);
procedure add_by_hand(var size:longint);
procedure delete_by_hand(var size:longint);
procedure search_def;
procedure game;
procedure change_pass;
procedure info;
     end;

var database:voc;
implementation

procedure voc.info;      {some information about program for user}
var info_file:text; info_string:string;
begin
  gotoxy(20,4);
  writeln('HELP');
  gotoxy(0,6);
  assign(info_file,'info.txt');  {information is downloading from INFO.TXT}
  {$I-}
  reset(info_file);
  {$I+}
  if IOResult<>0 then writeln('No information. Something is corrupted')
  else begin
  while not(eof(info_file)) do
  begin
  readln(info_file,info_string);
  writeln(info_string);
  end;
  close(info_file);
       end;
  gotoxy(18,24);
  writeln('PRESS ANY KEY for exit');

  readkey;
  exit;
end;

procedure voc.start;         {initialization of database}
var pass_file:text;
begin
 flag:=false;
 repeat

 if flag then
 begin
 clrscr;
 writeln('VOC.DAT is not found. PRESS ANY KEY');
 readkey;
 flag:=false;
 exit;
 end;
 {$I-}
   assign(main_file,'Voc.dat');
   reset(main_file);
 {$I+}
 flag:=true;
 until ioresult=0;
 size:=filesize(main_file);
 close(main_file);
 assign(pass_file,'Security.xxx');     {downloading of information for authorization}
 reset(pass_file);
 readln(pass_file,password);
 close(pass_file);
end;



procedure voc.convert_from_txt;       {downloading database from txt-file}
var ft:text; c:char;  flag:boolean; def3:def;
 tmpc:char; answer, tmps, fpath,way:string;  k,i:longint;
begin
     k:=1;
     {authorization}
 if password<>'' then begin

  repeat
  clrscr;
  if k=6 then begin writeln('Sorry, but you can''t change database');
  exit; end;
  writeln('Please enter your secret password');

  if k>1 then  begin
  textcolor(red);
  writeln('  (',6-k,' tries left)');
  textcolor(black); end;

  readln(answer);
  inc(k);
  until answer=password;         end;
  clrscr;
    {linking to user's file}
    writeln('Input file name');
    writeln;
    writeln('[Example:] Vocabulary');
    readln(fname);
    CLRSCR;
    writeln('Input filepath. Press ENTER if it is in the database folder');
    writeln;
    writeln('[Examples:]  D:\Folder1\');
    readln(fpath);

    way:=fpath+fname+'.txt';
    writeln(fpath+fname+'.txt');
    flag:=false;
    for i:=0 to length(way) do
    if way[i]=' ' then flag:=true;
    if flag then way:=''''+way+'''';
    readkey;
    {$i-}
    assign(ft,way);
    reset(ft);
    {$i+}
    if ioresult<>0 then begin writeln('Txt file not found. Press ENTER');
    fname:='Vocabulary';
    readkey; exit; end;
    {downloading information from user's file}
    rewrite(main_file);
    repeat

    tmps:='';
    repeat
    repeat
    read(ft,tmpc);
    until   tmpc<>'';
    if tmpc<>'-' then
    tmps:=tmps+tmpc;
    until (tmpc='-') or eoln(ft);
    if not eoln (ft)
    then

    read(ft,tmpc);

    delete(tmps,length(tmps),1);
    def3.word:=tmps;

    k:=1;
    repeat
    tmps:='';
    repeat
    repeat
    read(ft,tmpc);
    until   tmpc<>'';
    if tmpc<>',' then
    tmps:=tmps+tmpc;
    until (tmpc=',') or eoln(ft);
    if not eoln (ft)
    then

    read(ft,tmpc);


    def3.trans[k]:=tmps;


    def3.trans[k+1]:='';
    k:=k+1;
    until eoln(ft);
    readln(ft);
    write(main_file,def3);


    until eof(ft);
    close(ft);
    close(main_file);
    reset(main_file);
    size:=filesize(main_file);
    close(main_file);
    {message to user about result}
    writeln('Information from ',fname,'.txt is downloaded into database');
    writeln('PRESS ESC');
    while keypressed do readkey;
    c:=readkey;   if c=#27 then exit;
end;



procedure voc.add_by_hand;   {adding words to database}
var sign,answer,inp_word,inp_def:string;   c:char;      i,k,j:longint;   def1a,def4:def; flag:boolean;
begin
 flag:=false;
  k:=1;
  {authorization}
 if password<>'' then begin
  repeat
  clrscr;
  if k=6 then begin writeln('Sorry, but you can''t change database');
  exit; end;
  writeln('Please enter your secret password');
  if k>1 then  begin
  textcolor(red);
  writeln('  (',6-k,' tries left)');
  textcolor(black); end;
  while keypressed do readkey;
  c:=readkey;
  if c=#27 then exit;
  readln(answer);
  inc(k);
  until answer=password;         end;
  clrscr;
  reset(main_file);
  repeat
  j:=0;
  writeln('Input new word');
  repeat

  readln(inp_word);
  until inp_word<>'';
  {search for same words}
  while j<filesize(main_file) do begin
  seek(main_file,j);
  read(main_file,def4);
  if inp_word=def4.word
  then begin

 writeln('At first you must delete an old same word');
 flag:=true;
 end;

  inc(j);
  end;
  if flag=false then begin
      seek(main_file,filesize(main_file));
  j:=0;
  {adding}
  with def1a do  begin


  word:=inp_word;

  writeln('Input meanings');
  i:=0;
 repeat
 i:=i+1;

  readln(trans[i]);

 until trans[i]='';
 end;
     write(main_file,def1a);       end;
 {dialog with user: to exit or to continue}
 writeln('Press Esc or continue adding');
 while keypressed do readkey;
 c:=readkey;

 until c=#27;
 size:=filesize(main_file);
 close(main_file);
end;



procedure voc.game;     {studying new words in game mode}
var answer,correct:string; def2:def; q,rand,i,count_of_turns:longint;
       letter,keycode, c:char; f:byte;
    letters:set of char;
    right_letters, false_letters:set of char;
    false: array [1..20] of char;
    begin
    randomize;

    reset(main_file);
    if filesize(main_file)=0 then exit;
    {search for word to ask}
    q:=1;
    repeat
    rand:=random(filesize(main_file)+1);
    until rand<>0;
    seek(main_file,rand-1);
    read(main_file,def2);
    correct:=def2.word;
    if (length(correct)=0) or (length(def2.trans[1])=0) then exit;
    {asking by output of defenitions}
    writeln('Can your guess?');
    writeln;
    writeln(length(correct),' symbols');
    writeln;
    textcolor(red);
    writeln('Translate from one language to another:');
    writeln;
    repeat

    writeln(def2.trans[q]);
    q:=q+1;
    until  def2.trans[q]='';
    writeln;
    if upcase(correct[1])=correct[1] then begin
    textcolor(blue);
    write('First letter is ');
    textcolor(red);
    writeln(correct[1]);  end;
    writeln;
    textcolor(black);
    letters:=[];
    right_letters:=[];
    false_letters:=[];

    f:=0;
     for i:=1 to length(correct) do
     letters:=letters+[correct[i]];
     if upcase(correct[1])=correct[1] then
     letters:=letters-[correct[1]];
     if upcase(correct[1])=correct[1] then
     right_letters:=right_letters+[correct[1]];
     count_of_turns:=length(correct);
    repeat
     writeln(count_of_turns,' tries left');
     writeln('Input letter');
     repeat
     readln(letter);
     until (not (letter in right_letters)) and (letter<>'')
     and (not (letter in false_letters));
     clrscr;
     if letter in letters  then begin
     letters:=letters-[letter];
     right_letters:=right_letters+[letter];    end
     else begin
     false_letters:=false_letters+[letter];
     inc(f);
     false[f]:=letter;

     {output of correct and false letters}
     dec(count_of_turns);  end;
     if f<>0 then begin
     textcolor(red);
     write('Sorry, no such symbols: ');
     for i:=1 to f do
     write(false[i],' ');
     writeln;
     textcolor(black); end;
     for i:=1 to length(correct) do  begin
     if (correct[i] in letters)
     then      begin
     textcolor(blue);
     write('_ ');
     textcolor(black);
               end
     else   begin
     textcolor(blue);
     write(correct[i],' ');
     textcolor(black);
     end;        end;
     writeln;



    writeln('Can your guess?');
    writeln;
    writeln(length(correct),' symbols');
    writeln;
    q:=1;
    repeat

    writeln(def2.trans[q]);
    q:=q+1;
    until  def2.trans[q]='';
    writeln;
    writeln;
    until (letters=[]) or (count_of_turns=0);
    clrscr;
    {end of game and output of final result}
    if letters=[] then answer:=correct else answer:='';

    if answer=correct then begin
    textcolor(blue);
    writeln('Yes!');
    textcolor(black);
    write('This is ');
    textcolor(blue);
    writeln(correct);
    textcolor(black);
    end
    else
    begin
    textcolor(red);
    writeln('No :(');
    textcolor(black);
    write('Correct answer is ');
    textcolor(lightblue);
    writeln(correct);
    textcolor(black);
    end;
    writeln('Press ENTER');
    readkey;
    Close(main_file);
end;

procedure voc.change_pass;    {to change authorization password}
var answer1, answer2:string; k:byte;  pass_file:text;  c:char;
begin
  {authorisation}
  k:=1;
  if password<>'' then begin
  writeln('Please, input old password');
  repeat
  if k=6 then begin writeln('Please, input old password');
  exit; end;

  if (k>1) and (k<6) then begin textcolor(red);
  writeln('  (',6-k,' tries left)');    textcolor(black);  end;

  readln(answer1);
  inc(k);
  until answer1=password; end;
  k:=0;
  repeat
  clrscr;
  if k=6 then
  begin writeln('Sorry, but you can''t change password. PRESS ENTER');
   end;
  if k>0 then writeln('Something wrong. Please, try again');
  {asking for new password}
  writeln;
  writeln('Input new password. Press Enter if you don''t want any password');
  readln(answer1);
  if answer1<>'' then begin
  {confirming of new password}
  writeln('Please, confirm (input one more time) new password');
  readln(answer2);  end else answer2:='';
  k:=k+1;
  until answer1=answer2;
  password:=answer1;
  {retaining of new password}
  assign(pass_file,'Security.xxx');
  rewrite(pass_file);
  write(pass_file, password);
  close(pass_file);
end;

procedure voc.search_def; {search in database}

var def1b:def;  i,q,j,k,set_count,similar,count,ideal:longint; tmp:text;  out1a,qt:string;     flag:boolean;
 quest_set, tmp_set:set of char;  c,key:char;
 qt_letters:set of char;    similar_words:array [1..100] of string[20];
begin
  repeat
  clrscr;
  {asking for word to search in database}
   writeln('Input word to search');
  repeat
  readln(qt);
  until qt<>'';
  qt_letters:=[];     set_count:=0;
  for i:=1 to length(qt) do  begin
  qt_letters:=qt_letters+[qt[i]];  inc(set_count); end;

   flag:=false;
   reset(main_file);
         i:=0;
         count:=0;
       while i<filesize(main_file) do begin
             seek(main_file,i);
             read(main_file,def1b); q:=1;
             similar:=0;
             for j:=0 to length(def1b.word) do
             if  (def1b.word[j] in qt_letters) then inc(similar);

             if (similar>=set_count) and (count<100) then
             begin

             inc(count);

             similar_words[count]:=def1b.word;
             end;
             {search by title language}
             if def1b.word=qt then

             repeat

             textcolor(red);

             writeln(def1b.trans[q]);

             flag:=true;
             q:=q+1;
             until  def1b.trans[q]='';
             {search by language of definitions}
             q:=1;
             repeat
             if def1b.trans[q]=qt then begin

             textcolor(red);

             writeln(def1b.word);
             flag:=true;
             end;




             q:=q+1;


             until  def1b.trans[q]='';

             i:=i+1;
                                           end;



   textcolor(black);

   if flag=false then begin
   writeln('No results for this word');
   if count<>0 then
   {output of words with same letters}
   writeln('Maybe, you tried to find one of this words?');
   textcolor(blue);
   i:=0;
   repeat
   inc(i);
   writeln(similar_words[i]);
   until (i=15) or (i=count);
   textcolor(black);
   end;

   close(main_file);
   writeln;
   writeln('Press ESC for exit or ANY OTHER KEY for new search');
   key:=readkey;
   until key=#27;
end;


procedure voc.delete_by_hand;        {erasing words}
var i,j,k:longint; c:char;     dt,def1d:def;  flag:boolean;    answer,qu:string;
begin
  {authorisation}
  k:=1; if password<>'' then begin
  repeat
  clrscr;
  if k=6 then begin writeln('Sorry, but you can''t change database');
  writeln('Press ENTER');


  readkey;
  exit; end;
  writeln('Please enter your secret password');
  if (k>1) and (k<6) then begin textcolor(red);
  writeln('  (',6-k,' tries left)');    textcolor(black);  end;
  readln(answer);
  inc(k);
  until answer=password; end;
  {asking for word to delete}
  writeln('Input word to delete');
  repeat
  readln(qu);
  until qu<>'';
  clrscr;
  flag:=false;
  reset(main_file);
    i:=0;
    {database erasing}
    if qu='Delete all words' then begin seek(main_file,0); truncate(main_file);
    flag:=true; writeln('Database is clean');
    writeln('Press ENTER');
    readkey;
    end;
    {one-word erasing}
    while i<filesize(main_file) do begin
    seek(main_file,i);
    read(main_file,def1d);
    if def1d.word=qu then    begin if filesize(main_file)<>1 then
                                    for   j:=i to filesize(main_file)-2 do
                                             begin
                                                  seek(main_file,j+1);
                                                  read(main_file,dt);
                                                  seek(main_file,j);
                                                  write(main_file,dt);

                                             end;
                                             seek(main_file,filesize(main_file)-1);
                                             truncate(main_file);
                                             writeln('Successful');
                                             writeln('Press ENTER');

                                             readkey;
                                                 flag:=true;
                                end; i:=i+1;
                                end;
    if flag=false then begin
    writeln('Word is not found');
    writeln('Press ENTER');

   readkey;
   end;
  size:=filesize(main_file);
  close(main_file);

end;

end.