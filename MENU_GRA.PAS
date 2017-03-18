unit menu_graph;
interface
  procedure execute;
implementation
uses graph, crt, dos, lex;
procedure execute;
var voc:vocabulary; quest,password,head,headline:string; answer,c:char; x,y,gd,gm,er:integer;
    date1, date2, date3, date4:word;    flag:boolean;     size:longint;
    ds1, ds2, ds3, ds4:string;     i:byte;
begin
  {database initialization}
  headline:='VOCABULARY';
  database.start(flag, size);
  if flag=false then exit;
 head:='Vocabulary';
 flag:=false;
  {graphic environment initialization}
 repeat
  if flag=false then begin
  gd:=0;
 initgraph(gd,gm,'');
 er:=graphresult;
 if graphresult<>0 then begin
 writeln(grapherrormsg(er));
 writeln;
 writeln('Press ENTER');
 readkey;
 exit;
 end else flag:=true;
 end else setgraphmode(gm);
 setbkcolor(7);
 {menu text}
 if length(head)<16 then begin
 headline:='';
 for i:=1 to length(head) do
 headline:=headline+upcase(head[i]); end;
 setcolor(magenta);
 settextstyle(0,0,2);
 outtextxy(150,10,headline);
 setcolor(1);
 outtextxy(20,150,'Add a new');
 outtextxy(20,170,'Delete an old');
 outtextxy(20,70,'Search');
 outtextxy(20,205,'Study');
 outtextxy(20,260,'Download from txt');
 outtextxy(20,280,'Help');
 outtextxy(20,300,'Change password');
 outtextxy(20,395,'Exit');
 setcolor(cyan);
 outtextxy(320,70,'ENTER');
 outtextxy(320,150,'+');
 outtextxy(320,170,'DEL');
 settextstyle(0,0,2);
 outtextxy(320,205,'BACKSPACE');
 outtextxy(320,260,'F3');
 outtextxy(320,280,'F1');
 outtextxy(320,300,'F9');
 settextstyle(0,0,2);

 outtextxy(320,395,'ESC');
 settextstyle(0,0,1);
 getdate(date1,date2,date3,date4);

 setcolor(red);
 str(date1,ds1);
 str(date2,ds2);
 str(date3,ds3);
 outtextxy(470,430,'Today  ');
 outtextxy(530,430,ds3+'.');

 outtextxy(555,430,ds2+'.');
 outtextxy(575,430,ds1);

 setcolor(red);
 settextstyle(0,0,2);
 str(size,ds4);

 if size=1 then
 outtextxy(500,50,'1 word')
 else
 if size<10 then    begin
 outtextxy(500,50,ds4);
 outtextxy(520,50,' words'); end
 else
 if size<100 then  begin
 outtextxy(480,50,ds4);
 outtextxy(520,50,' words'); end
 else        begin
 outtextxy(460,50,ds4);
 outtextxy(520,50,' words'); end;
 repeat
 answer:=readkey;
 until (answer=#43)  or (answer=#83) or (answer=#13)
 or (answer=#27) or (answer=#8) or (answer=#61)
 or (answer=#67) or (answer=#59);
 {crt-mode initialization}
 restorecrtmode;

 textbackground(white);
 textcolor(black);

 clrscr;
 {synchronization with user's commands}
 case answer of
  #43:database.add_by_hand(size);
  #83:database.delete_by_hand(size);
  #13:database.search_def;
  #27:exit;
  #8:database.game;
  #61:database.convert_from_txt(size,head);
  #67:database.change_pass;
  #59:database.info;
 end;

 until 0=1;
 end;
end.