package ThousandWords;
# by Henning Møller-Nielsen. The inspiration I got from http://www4.telge.kth.se/~d99_kme/
# look at http://rto.dk/images/camel.html or http://rto.dk/images/llama.html for the first versions
# (and I look like this: http://rto.dk/images/henning.htm)

use strict;
use GD;

$ThousandWords::NAME	= 'ThousandWords';
$ThousandWords::VERSION	= '0.05';

# version history (a bit of an overkill, but hey - this is Fun!)
# 0.01	Not really a module, just a script
# 0.02	'ThousandWords.pm' came to life
# 0.03	Fixed an error so the first text in a black image wouldn't be white
# 0.04	Fixed an error so the first text in a black image wouldn't be larger
#		than the rest and so spaces no longer would be used
# 0.05	Ah - added POD
# future:
#		ANSI colored text?
#		Resizing of image?
#		?

sub giveme ($$) {			# call with ThousandWords::giveme(GDIMAGE, TEXT)
	my ($image, $text) = @_;
#	$text =~ s¤\s+¤ ¤g;
	$text =~ s¤\s+¤¤g;	# best results from no spaces
	my @text = split //, $text;

	my ($x, $y) = $image->getBounds();

	@text = (@text, @text) while ($x*$y > scalar(@text));

	my ($R, $G, $B) = (-1);

	my $result = qq¤<CENTER><NOBR><FONT SIZE="1" FACE="Courier New, Courier"><FONT COLOR="white">¤;

	my $j;
	for ($j = 0; $j < $y; $j += 2) {	# I only look at every second line, this is a hack
		my $i;
		for ($i = 0; $i < $x; $i++) {
			my $index = $image->getPixel($i, $j);
			my ($r,$g,$b) = $image->rgb($index);
			unless (($r == $R) and ($g == $G) and ($b == $B)) {
				($R, $G, $B) = ($r, $g, $b);
				my $color = '#' . sprintf("%.2X%.2X%.2X", $r, $g, $b);
				$result .= qq¤</FONT><FONT COLOR="$color">¤;
			}
			my $char = shift @text;
			$char =~ s¤<¤&lt;¤g;
			$char =~ s¤>¤&gt;¤g;
			$result .= $char;
		}
		$result .= "\n<BR>";
	}

	$result .= qq¤</FONT></NOBR></CENTER>\n¤;

	return $result;
}

1;

############################ POD #############################

=head1 NAME

ThousandWords - convert an image to colored HTML text

=head1 SYNOPSIS

	$text = ThousandWords::giveme($image, $filltext);

=head1 DESCRIPTION

ThousandWords is a module designed to take a GD image and a string as input and
return an HTML formatted and colored text, resembling the image made out of the
string, repeated as necessary.

=head1 FUNCTIONS

=over 5

=item C<giveme>

C<giveme(IMAGE, STRING)>

Returns a HTML formatted string, colored to resemble IMAGE. The string consists
of the letters and characters from STRING.

=back

=head1 EXAMPLE

	use GD;
	use ThousandWords;

	my $filltext = 'ThisIsALittleTextLittleTextLittleText';

	open(FILE, '< demo.png') || die('horribly');
	my $image = newFromPng GD::Image(FILE) || die('miserably');
	close(FILE) || die('pathetically');

	my $text = ThousandWords::giveme($image, $filltext);

	print "Content-type: text/html\n\n<HTML><BODY>$text</BODY></HTML>\n";

=head1 MORE EXAMPLES

	Made with the v. 0.01 (just a script, inspired by http://www4.telge.kth.se/~d99_kme/)

	http://rto.dk/images/camel.html
	http://rto.dk/images/llama.html
	http://rto.dk/images/henning.html (me)

	Made with the v. 0.03

	http://rto.dk/images/neptune.html
	http://rto.dk/images/mars.html
	http://rto.dk/images/pluto_charon.html
	http://rto.dk/images/earth.html
	http://rto.dk/images/saturn.html
	http://rto.dk/images/jupiter.html (here the reason for v. 0.04 is apparent)
	http://rto.dk/images/ira1.html
	http://rto.dk/images/ira2.html (my colleagues)

=head1 KNOWN BUGS

None, from a perl perspective. From an image perspective things look different :-)

=head1 AUTHOR ETC.

Henning Michael Møller-Nielsen, hmn@datagraf.dk

=cut
