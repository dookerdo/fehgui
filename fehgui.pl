#!/usr/bin/perl -sw

use Tk;
use feature qw/switch/;
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
$frame2_l = $frame2->Frame(-background => 'SlateGray');
$frame2_r = $frame2->Frame(-background => 'red', -padx=>2, -pady=>2);
$frame2_l->pack(-expand=>1,-anchor=>'w',-side=>'left', -fill=>'both');
$frame2_r->pack(-expand=>1,-side=>'right', -fill=>'both');
$frame3 = $mw->Frame(-background => 'SlateGray', -padx=>2, -pady=>2)->pack(-fill=>'both');

### WIDGET CREATE ###
my ($brand, $bselect, $bexit, $lbfiles, $rcenter, $rmax, $rtile, $rscale, $rfill, $layout);

# TOP
$dirx = $frame0->Label(-text=>"$directory_walls",-background=>'white');
$dirx->pack(-expand=>1,-side=>"left");
$bdir = $frame0->Button(-text=>'Change Dir',-command =>\&set_dir);
$bdir->pack(-side=>"left");

# MID
$brand = $frame1->Button(-text=>'Random',-command =>\&random_wall);

$rscale = $frame2_l->Radiobutton(-text=>"Scaled",-highlightbackground=>'SlateGray',-background=>'SlateGray',-value=>"scaled",-variable=>\$layout);
$rscale->select;
$rfill = $frame2_l->Radiobutton(-text=>"Fill",-highlightbackground=>'SlateGray',-background=>'SlateGray',-value=>"fill",-variable=>\$layout,-anchor=>'w');
$rcenter = $frame2_l->Radiobutton(-text=>"Center",-highlightbackground=>'SlateGray',-background=>'SlateGray',-value=>"center",-variable=>\$layout,-anchor=>'w');
$rmax = $frame2_l->Radiobutton(-text=>"Max",-value=>"max",-background=>'SlateGray',-highlightbackground=>'SlateGray',-variable=>\$layout,-anchor=>'w');
$rtile = $frame2_l->Radiobutton(-text=>"Tile",-background=>'SlateGray',-highlightbackground=>'SlateGray',-value=>"tile",-variable=>\$layout,-anchor=>'w');

$lbfiles = $frame2_r->Scrolled("Listbox", -scrollbars=>"se", -exportselection=>0,-selectmode=>"single");

# Bottom
$bselect = $frame3->Button(-text=>'Select',-command =>\&select);
$bexit = $frame3->Button(-text=>'Close',-command => sub{exit});


### WIDGET PACK/GEO ###

$brand->pack(-expand=>1,-fill=>'x');
#$rscale->pack(-side=>'left');
#$rfill->pack(-side=>'left');
$rscale->grid(-row=>0,-column=>0,-sticky=>'w');
$rfill->grid(-row=>1,-column=>0,-sticky=>'w');
$rcenter->grid(-row=>2,-column=>0,-sticky=>'w');
$rmax->grid(-row=>3,-column=>0,-sticky=>'w');
$rtile->grid(-row=>4,-column=>0,-sticky=>'w');

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
	$file = "$directory_walls/" . shift;
	
	given($layout){
		when('scaled'){ $opt='--bg-scale';}
		when('fill'){ $opt='--bg-fill';}
		when('max'){ $opt='--bg-max';}
		when('tile'){ $opt='--bg-tile';}
		when('center'){ $opt='--bg-center';}
	}

	# Call feh
	system("feh $opt '" . $file . "'");
}

### OPEN CHOOSEDIR ###
sub set_dir{
	my $directory_walls_tmp = $mw->chooseDirectory(-initialdir=>"$directory_walls");
	if($directory_walls_tmp){ # Make sure they didn't cancel
		$directory_walls = $directory_walls_tmp;
		&set_list; #refresh listbox
	}
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
