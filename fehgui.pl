#!/usr/bin/perl -sw

use Tk;

#############################
### VARIABLES / PREPATORY ###
my $directory_walls;
if(!$x){
	$directory_walls = "/home/" . ($ENV{LOGNAME} || $ENV{USER}) . "/wallpaper";
}else{
	$directory_walls = $x;
}

if(!$x && @ARGV){print("\nHELP FILE\n");exit;} #ADD A HELP FILE LATER


###############
### PROGRAM ###

my $mw = new MainWindow(-title=>"FehGui",-background=>'blue');
my($frame1,$frame2,$frame3,$frame2_l,$frame2_r,$frame0);

### FRAME GEO ###
$frame0 = $mw->Frame(-background => 'black', -padx=>2, -pady=>2)->pack(-fill=>"both");
$frame1 = $mw->Frame(-background => 'SlateGray', -padx=>2, -pady=>2)->pack(-fill=>"both");
$frame2 = $mw->Frame(-background => 'SlateGray', -padx=>2, -pady=>2)->pack(-fill=>"both",-expand=>1);
$frame3 = $mw->Frame(-background => 'SlateGray', -padx=>2, -pady=>2)->pack(-fill=>'both');
$frame2_l = $frame2->Frame(-background => 'SlateGray');
$frame2_r = $frame2->Frame(-background => 'red', -padx=>2, -pady=>2);
$frame2_l->pack(-expand=>1,-anchor=>'w',-side=>'left', -fill=>'both');
$frame2_r->pack(-expand=>1,-side=>'right', -fill=>'both');

### WIDGET CREATE ###
my ($brand, $bselect, $bexit, $lbfiles, $rscale, $rfill, $layout);

$dirx = $frame0->Label(-text=>"$directory_walls",-background=>'white');
$dirx->pack(-expand=>1,-side=>"left");
$bdir = $frame0->Button(-text=>'Change Dir',-command =>\&set_dir);
$bdir->pack(-side=>"left");

$brand = $frame1->Button(-text=>'Random',-command =>\&random_wall);
$rscale = $frame2_l->Radiobutton(-text=>"Scaled",-value=>"scaled",-variable=>\$layout);
$rscale->select;
$rfill = $frame2_l->Radiobutton(-text=>"Fill",-value=>"fill",-variable=>\$layout,-anchor=>'w');
$lbfiles = $frame2_r->Scrolled("Listbox", -scrollbars=>"se", -exportselection=>0,-selectmode=>"single");
$bselect = $frame3->Button(-text=>'Select',-command =>\&select);
$bexit = $frame3->Button(-text=>'Close',-command => sub{exit});


### WIDGET PACK/GEO ###

$brand->pack;
#$rscale->pack(-side=>'left');
#$rfill->pack(-side=>'left');
$rscale->grid(-row=>0,-column=>0,-sticky=>'w');
$rfill->grid(-row=>1,-column=>0,-sticky=>'w');
$bselect->pack(-side=>'left',-fill=>'both',-expand=>1);
$bexit->pack(-side=>'right',-fill=>'both');
$lbfiles->pack(-expand=>1,-fill=>'both');
$lbfiles->Subwidget("listbox")->selectionSet(0);

### MAIN LOOP ###
&set_list;
MainLoop;


############
### SUBS ###

# RANDOM BUTTON. SETS WALLPAPER (calls set_wall)
sub random_wall{
	my $opt;
	my $size = $lbfiles->Subwidget("listbox")->size(); #gets size of listbox (amount of walls)
	my $ran = int(rand($size)); # choose random wall
	&set_wall($lbfiles->Subwidget("listbox")->get($ran));
}


# SELECT BUTTON. SETS WALLPAPER (calls set_wall)
sub select{
	my $selection = $lbfiles->Subwidget("listbox")->curselection();
	&set_wall($lbfiles->Subwidget("listbox")->get($selection));	
}


# SETS THE WALLPAPER
sub set_wall{
	my ($opt,$file);
	$file = "/home/koni/wallpaper/" . shift;
	if($layout eq 'scaled'){
		$opt = "--bg-scale"
	}elsif($layout eq "fill"){
		$opt = "--bg-fill"
	}
	system("feh $opt '" . $file . "'");
}

### OPEN CHOOSEDIR ###
sub set_dir{
	$directory_walls = $mw->chooseDirectory();
	&set_list; #refresh listbox
}

### POPULATE LISTBOX ###
sub set_list{	

	$lbfiles->delete(0,$lbfiles->size());
	foreach(<$directory_walls/*>){
		$_ =! m/([^\/]+)$/;
		$_ = $1;
		$lbfiles->insert("end","$_");
	}
}
