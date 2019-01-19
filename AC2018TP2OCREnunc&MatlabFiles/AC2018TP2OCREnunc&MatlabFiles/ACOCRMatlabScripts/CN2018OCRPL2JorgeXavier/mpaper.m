% Aprendizagem Computacional, Computação Neuronal e Sistems Difusos, DEI,
% dois mil e dezoito.
% Digitalização de um caráter desenhado manualmente .
% Usa-se para construir as matrizes de dados P, que se guarda em formato .mat 
% Também pode servir  para estabelecer os vectores alvo ("target") num problema de
% classificação: desenham-se cuidadosamente na grelha produzida pela função, guardando-se
% aí como a matriz T.No entanto é preferível usar para este efeito o
% ficheiro PerfectArial.mat que contém os 10 carateres arial perfeitos,

function mpaper(varargin)

warning off MATLAB:divideByZero

% Neste trabalho prático esta função é usada simplesmente 
% para gerar entradas a partir de uma grelha onde o utilizador desenha, com
% o rato, um algarismo (0 a 9). A célula do algarismo é dividida numa
% grelha 16x16 e cada quadrícula é transformada num 1 ou num 0, conforme
% esteja ou não preenchida pela linha desenhada nessa célula.
%
% Pode-se chamar de um script, com um número variável de argumentos (varargin, variable arguments input) ou correr  
% directamente da linha de comando, escrevendo simplesmente mpaper. Aparece
% uma quadrícula 5x10.Este texto corresponde a 2018.  Desenha-se um algarismo em cada célula.
% O resultado da "digitalização" da quadrícula é armazenado na estrutura
% data.X. Cada coluna de 256 linhas corresponde a um quadrado.
%
% Este ficheiro foi adaptado por J. Henriques para a cadeira de Computação
% Adaptativa. Ver abaixo autoria original.

%Resumindo:
% 1º Corre-se mpaper (sem fazer classificação, comentando a linha feval nº 209 neste ficheiro)

% 2º Desenham-se caracteres em número suficiente, um em cada quadrícula
% apresentada, para construir os dados de treino. Para um classificador
% razoável são necesários pelo menos 500 carateres para treino.

% 2º Usa-se a matriz das entradas P assim criada para o nosso problema,
% activando as linhas 178 e 189 e desactivando a linha 217 e 218.
% 
% 3º Para se graficar cada entrada numa grelha, usa-se a função grafica
% (X,Y, Z), que permite visualizar uma, duas, ou três entradas.
% o botão central do rato, quando não existe, pode ser substituído pela
% combinação Shift+botão esquerdo  (Shift para maiúsculas).

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
%
% MPAPER Allows to enter handwritten characters by mouse.
%
% Synopsis:
%  mpaper
%  mpaper( options )
%  mpaper({'param1',val1,...})
%
% Description:
%  This script allows a user to draw images by mouse to 
%  figure with a grid. The drown images are normalized to
%  exactly fit the subwindows given by the grid.
%  Control:
%    Left mouse button ... draw line.
%    Right mouse button ... erase the focused subwindow.
%    Middle mouse button ... call function which proccess the
%      drawn data. (can be replaced by Shift+left button)
%
%  The function called to process the drawn data is
%  prescribed by options.fun. The implicite setting is 'ocr_fun'
%  which calls OCR trained for handwritten numerals and displays 
%  the result of recognition.
%
% Input:
%  options.width [int] Width of a single image.
%  options.height [int] Height of a single image.
%  options.fun [string] If the middle mouse button is 
%    pressed then feval(fun,data) is called where
%    the structure data contains:
%    data.X [dim x num_images] images stored as columns
%       of size dim = width*height.
%    data.img_size = [height,width].
%  
%  Example:
%   open ocr_demo.fig
%
% (c) Statistical Pattern Recognition Toolbox, (C) 1999-2003,
% Written by Vojtech Franc and Vaclav Hlavac,
% <a href="http://www.cvut.cz">Czech Technical University Prague</a>,
% <a href="http://www.feld.cvut.cz">Faculty of Electrical engineering</a>,
% Modifications:
%  9-sep-03, VF, 
%  8-sep-03, MM, Martin Matousek programmed the GUI enviroment.
%  usado em dois mil e dezoito
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
if nargin >= 1 && ischar(varargin{1}),
  switch varargin{1},
    case 'Dn', Dn;
    case 'Up', Up;
    case 'Plot', Plot;
  end
else
   
  if nargin >=1, options = c2s(varargin{1}); else options=[]; end
  
  % function called when middle button is pressed
  if ~isfield( options, 'fun'), options.fun = 'ocr_fun'; end
  
  % resulting resolution of each character
  if ~isfield( options, 'width'), options.width = 16; end
  if ~isfield( options, 'height'), options.height = 16; end
  
  % brush stroke within del_dist is deleted
  if ~isfield( options, 'del_dist'), options.del_dist = 0.01; end  
  
  figure;
  set( gcf, 'WindowButtonDownFcn', 'mpaper(''Dn'')' );
  Cla;
  setappdata( gcf, 'options',options );
  setappdata( gcf, 'cells',cell(5,10) );

end

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function Up(varargin)
    set( gcf, 'WindowButtonMotionFcn', '' );
    set( gcf, 'WindowButtonUpFcn', '' );
    
    last = getappdata( gcf, 'last' );
    x = get( last, 'xdata' );
    y = get( last, 'ydata' );
    
    if ~isempty(x)
     [r c]= index( [ x(1) y(1) ] );
    
     cells = getappdata( gcf, 'cells' );
     cells{r,c} = [cells{r,c} last];
     setappdata( gcf, 'cells', cells );
    end

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function Dn(varargin)
      switch get(gcf, 'SelectionType')   % clicked mouse button
          
       case 'normal'  % left     se carregar no botão esquerdo do rato
          setappdata(gcf, 'last', [] );
          set( gcf, 'WindowButtonMotionFcn', 'mpaper(''Plot'')' );
          set( gcf, 'WindowButtonUpFcn', 'mpaper(''Up'')' );
          Plot
          
        case 'extend'  % middle  se carregar no botão do meio do rato ou então na combinação Shift+botão esquerdo
            disp('----------- Classify -----------')
         
          cells = getappdata( gcf, 'cells' );
          for r =  1:5
            for c = 1:10
              if( ~isempty(cells{r,c}) )
                normalize( ([r c]-1)/10+0.001 , [0.098 0.098], cells{r,c} );
              end
            end
          end
          if(1)
          options=getappdata( gcf, 'options');
          handles=findobj(gca, 'tag', 'brush_stoke');            
          bmp = plot2bmp( handles);
          if ~isempty(options.fun),
             data.img_size = [options.height,options.width];
             dim = prod(data.img_size);
             data.X = zeros(dim,10*5);
             for j=1:5,
               for i=1:10,
                   xrange=(i-1)*options.width+1 : i*options.width;
                   yrange=(j-1)*options.height+1 : j*options.height;
                   x = reshape(bmp(yrange,xrange),dim,1);
                   data.X(:,i+(j-1)*10)= x;
                end
             end
             
 % Até aqui foi digitalizada a quadrícula 5x10, estando os resultados
 % em data.X. Seguindo a notação usada na aula teórica, poderemos
 % construir a partir deles o vector de entradas P, fazendo simplesmente
 % ativar a criação de P
 
             P_validation=data.X;
             ind_validation=find( sum(data.X) ~= 0);% considerar em ind as colunas de soma não-nula; se uma coluna tem soma nula,
               % é porque no quadrado respectivo nada se escreveu (não há nenhum 1).
 %              
 %            save P
 %save Save workspace variables to file. (from help save).
 %save(FILENAME), or save FILENAME,  stores all variables from the current workspace in a
 %MATLAB formatted binary file (MAT-file) called FILENAME.
 % We want to save only P, and for that we must specify that we only want
 % to save P; for that we must write
 
              %save P_validation.mat P_validation
           
 % and a mat file called P is created having inside the matrix P.Then we can
 % load P, and rename the matrix P, by clicking on P with the right mouse
 % button and chose Rename.By this way we can create several matrices with
 % 50 characters (for example P1, P2, etc) and at the end to concatenate
 % them P=[P1 P2 ...] obtaining the input matrix for the classifier. At the
 % end we write save P and the total matrix P is daved as P.mat containing
 % only the matrix P.
 
 % By the same reason, to save only ind we write
 
             %save ind_validation.mat ind_validation
             
 % para se analisar o procedimento de leitura do desenho, sua representação
 % em binário e depois a construção de data.X, ver o ficheiro bmp e a
 % função bmp2plot mais à frente
 % neste momento estão na directoria de trabalho a matriz P.mat e o vector ind.mat.
 % não usar este ficheiro para  a classificação; por isso comentar sempre a linha seguinte 
 
             feval(options.fun,data);
             
 % feval vai calcular a função options.fun, que por defeito é a ocr_fun;
 % ocr_fun chama a função myclassify que deve ser escrita pelo utilizador. 
 %
 % Se se pretender usar a função para definir a matriz T dos alvos, deve
 % activar-se a linha seguinte e desactivar a anterior save P.
 % Para criar P devem desativar-se comentando-as
 %          T=data.X;
 %          save T
 %
 % Pode confirmar usando a grafica para desenhar os alvos na quadrícula
 % 16x16.
 
           else             
             figure; 
             imshow(bmp,[]);
           end
%                        figure(7); 
%                       imshow(bmp,[]);
           end
            
        case 'alt'     % right  ( se carregar no botão direito do rato)
            disp('----------- Erased -----------')
          %          Cla
          cells = getappdata( gcf, 'cells' );
          x = get( gca, 'currentpoint' );
          [r c] = index(x([1 3]));
          if ~isempty(cells{r,c}) 
            set(cells{r,c}, 'erasemode','normal');
            delete(cells{r,c});
            cells{r,c} = [];
          end
          setappdata( gcf, 'cells', cells );
      end

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function Cla()
  cla;
  plot( [ 0 0 1 1 0 ], [ 0 .5 .5 0 0 ] );
  hold on;
  for i = 1:9, plot( [i/10 i/10],[0 .5] ); end
  for i = 1:4, plot( [0 1],[i/10 i/10] );  end

  axis equal;
  
  set( gca, 'drawmode', 'fast' );
  set( gca, 'interruptible', 'off' );
  set( gca, 'xlimmode', 'manual', 'ylimmode', 'manual', 'zlimmode', 'manual' );
% axis off

  title('DRAW:Left          ERASE:Right         Classify:Middle','FontSize',14,'Color','blue');

%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function Plot(varargin)
   x =get( gca, 'currentpoint' );
   if( x(1) > 0 && x(1) < 1 && x(3) > 0 && x(3) < 1 );
     l = getappdata(gcf, 'last');
     if( isempty( l ) ),
       l = plot( x(1), x(3), '.-' );
       set( l, 'erasemode', 'none', 'tag', 'brush_stoke', 'color', [0.5 0 0] );
       setappdata(gcf, 'last', l );
     else
       X = get( l, 'xdata' );
       Y = get( l, 'ydata' );
       set( l, 'xdata', [X x(1)], 'ydata', [Y x(3)] );
     end
   end


%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function bmp = plot2bmp( handles )
   options=getappdata( gcf, 'options');

   Width = options.width*10;
   Height = options.height*5;
   bmp = zeros( Height, Width );
   
   for i = 1:length(handles ),
      
%      X = get( handles(i), 'xdata');
%      Y = get( handles(i), 'ydata');
      points = get( handles(i), 'Userdata');
      X = points.xdata;
      Y = points.ydata;

      x1 = min(fix(X(1)*Width)+1,Width);
      y1 = min(fix(2*Y(1)*Height)+1,Height);
      for j=1:length( X )
        x2 = min(fix(X(j)*Width)+1,Width);
        y2 = min(fix(2*Y(j)*Height)+1,Height);

        n = max( ceil( max( abs(x2-x1), abs(y2-y1) ) * 2 ), 1 );
        a = [0:n]/n;
        
        x = round( x1 * a + x2 * (1-a) );
        y = Height - round( y1 * a + y2 * (1-a) ) + 1;
        bmp( y + (x - 1) * Height ) = 1;
        x1=x2; y1=y2;
      end
   end
  
%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function normalize( corner, sz, h )
  
x = get( h, 'xdata' );
y = get( h, 'ydata' );
if( iscell(x) ), x = [x{:}]; end
if( iscell(y) ), y = [y{:}]; end

mx = min( x );
Mx = max( x );
sx = Mx - mx;
my = min( y );
My = max( y );
sy = My - my;

centerx = (mx + Mx) / 2;
centery = (my + My) / 2;
center = corner + sz/2;

if( sy/sx >  sz(1)/sz(2) )
  scale = sz(1) / sy;
else
  scale = sz(2) / sx;
end

for hnd = h
%  set( hnd, 'erasemode', 'normal' );
%  set( hnd, 'xdata', ...
%    ( get( hnd, 'xdata' ) - centerx ) * scale + center(2), ...
%      'ydata', ...
%      ( get( hnd, 'ydata' ) - centery ) * scale + center(1) );

  points.xdata = ( get( hnd, 'xdata' ) - centerx ) * scale + center(2);
  points.ydata = ( get( hnd, 'ydata' ) - centery ) * scale + center(1);
  set( hnd, 'userdata', points );
end


%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
function [r, c] = index( x )
r = min( floor( x(2) * 10 ) + 1, 5 );
c = min( floor( x(1) * 10 ) + 1, 10 );
