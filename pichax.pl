#!/usr/bin/perl 

# 20/12/07
# pichax - a picture to colored ascii converter
# by Fivos Kefallonitis aka gorlist
# http://www.int0x80.gr/projects/pichax.txt
# pichax -h for usage info

use warnings;
use strict;
use Image::Magick;

# CHANGE THESE ACCORDINGLY
my $ilevel=5;
my $jlevel=9;
my $char='0';
# END CHANGE

my $program=$0;

if (@ARGV<2){
	usage();
	exit;
}

my $IMAGE = shift;
my $HTML = shift;
my $TEXT = shift;
my $txt;
undef $/;

if (defined $TEXT){
	if (-e $TEXT){
		open IN, '<', $TEXT or die "Could not open $TEXT";
		$txt=<IN>;
		close IN;
	}
	else{
		$txt=$TEXT;
	}
}

my $im=Image::Magick->new or die "Could not create image";
$im->Read($IMAGE);
my $file=$HTML;
open OUT, '>', $file or die "Could not open $file";

my ($height, $width) = $im->Get('height','width');
my ($i, $j, $r, $g, $b, $color, $code);
my $z=0;
my @special;

if (defined $txt){
 	@special=map { split // } split " ", $txt;
}

print OUT '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>pichax by gorlist</title>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
		<style type="text/css">
			body{
				background-color: #000000;
				font-family: sans-serif;
				font-size: 8px;
				line-height: 8px;
			}
		</style>
	</head>
	<body>';

for ($j=0; $j<$height; $j+=$jlevel){
	for ($i=0; $i<$width; $i+=$ilevel){
		$color = $im->Get("pixel[$i,$j]");
		($r, $g, $b, undef) = split(/,/, $color);
		$code = sprintf("#%02x%02x%02x", $r>>8, $g>>8, $b>>8);
		if (defined $txt){
			print OUT '<span style="color:'.$code.';">'.$special[$z % @special].'</span>';
			$z++;
		}
		else{
			print OUT '<span style="color:'.$code.';">'.$char.'</span>';
		}
	}
	print OUT '<br>';
}

print OUT '</body>
</html>';

close OUT;

sub usage{
	print "\n\n";
	print "pichax - a picture to colored ascii converter\n"; 
	print "					by Fivos Kefallonitis aka gorlist\n\n";
	print "Usage: $program [image] [.html output file] [file or text]\n";
	print "If you do not specify the third argument, '$char' will be used\n";
	print "\n\n";
}