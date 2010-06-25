# Copyright (C) 2010  Juan-Manuel Torres-Moreno
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -----	Divergence de Jensesn-Shannon   	V 0.3     7-10 decembre 2009
#  	Juan-Manuel Torres-Moreno LIA/Avignon   juan-manuel.torres@univ-avignon.fr
package JS ;
our $VERSION = '0.0130';
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(&jensen_shannon);

use strict ;
#------------------ Divergence de Jensen-Shannon : P = DISTRIBUTION_P ; P = P_w ; Q = DISTRIBUTION_Q ; Q = Q_w, w = symbols
# 	JS 	= 0.5 * SUM_w P Log ( P /(P+Q)/2 ) + Q Log ( Q/(P+Q)/2 ) 
# 	   	= 0.5 * SUM_w P Log ( 2P_w/(P_w+Q_w) ) + Q_w Log ( 2Q_w/(P_w+Q_w) )
sub jensen_shannon {
	my ($P, $Q) = @_;			# $P=pointeur dist P, $Q=pointeur dist Q  
	my $log_2   = log(2) ;		# Logarithme base 2
   	my %deja_vu = () ;			# Identifier les symboles de la distribution P
   	map{ $deja_vu{$_}++ } (keys %$P) ;
	my @symbols = sort keys %deja_vu ;	# Symbols de la distribution P
     	my $js      = 0 ; 					# init Jensen-Shannon
     	foreach my $mot (@symbols) { 		# Calcul de la divergence Jensen-Shannon
		$js 	+= $P->{$mot} * log( 2*$P->{$mot} / ( $P->{$mot} + $Q->{$mot} ) )/$log_2 	# P Log ( P /(P+Q)/2 )
			+  $Q->{$mot} * log( 2*$Q->{$mot} / ( $P->{$mot} + $Q->{$mot} ) )/$log_2 	# Q Log ( Q /(P+Q)/2 )
     	}
     	return $js/2 ;						# retourner divergence Jensen-Shannon
}
1;

__END__

=head1 NAME

JensenShannon - Compute the Jensen-Shannon divergence between two probability distributions 

=head1 SYNOPSIS

use strict  ;
use JS ;   						# Module Jensen_Shannon

my $A = "la plume de ma tante est la plus jolie" ; 	# Doc 1
my $B = "la plume est jolie" ; 					# Doc 2

my %A = unigrammes(split(/ /,$A));			# 1-grammes
my %B = unigrammes(split(/ /,$B)) ;
my %P  = () ;  my %Q = () ;				# Distributions de probabilités de P(A) et Q(B)
foreach my $mot (keys %A) {			
	$P{$mot} = $A{$mot}/keys %A ; 						
	if (exists $B{$mot}) 	{ $Q{$mot} = $B{$mot}/keys %B }
					else { $Q{$mot} = $A{$mot}/keys %A  }  # Smooth simple
}
print "Divergence JS = ", JS::jensen_shannon(\%P, \%Q),"\n" ;		# Divergence de Jensen-Shannon	

#---------------------- Calcul de 1-grammes
sub unigrammes {					
	my %unigrammes = () ;
	for (my $i = 0; $i < @_; $i++) {		# Parcourir chaque mot de $text
      		$unigrammes{$_[$i]}++;     		# Stocker le unigramme dans l'index du hachage %unigrammes
 	}
 	return %unigrammes 
}

=head1 DESCRIPTION

This module computes Jensen-Shannon divergence between two 
probabilities distribution.

Examples can be found in the distribution C<eg/> directory and the test
file.

=head1 METHODS

=head2 x_data

  $c->x_data( $y );
  $x = $c->x_data;

Return and set the one dimensional array reference data.  This is the
"unit" array, used as a reference for size and iteration.

=head2 y_data

  $c->y_data( $y );
  $x = $c->y_data;

Return and set the one dimensional array reference data.  This vector
is dependent on the x vector.

=head2 size

  $c->size( $s );
  $s = $c->size;

Return and set the number of array elements.

=head2 x_rank

  $c->x_rank( $rx );
  $rx = $c->x_rank;

Return and set the ranks as an array reference.

=head2 y_rank

  $ry = $c->y_rank;
  $c->y_rank( $ry );

Return and set the ranks as an array reference.

=head2 x_ties

  $xt = $c->x_ties;
  $c->x_ties( $xt );

Return and set the ties as a hash reference.

=head2 y_ties

  $yt = $c->y_ties;
  $c->y_ties( $yt );

Return and set the ties as a hash reference.

=head2 spearman

  $n = $c->spearman;

Spearman's rho rank-order correlation is a nonparametric measure of 
association based on the rank of the data values and is a special 
case of the Pearson product-moment correlation.

      6 * sum( (xi - yi)^2 )
  1 - --------------------------
             n^3 - n

Where C<x> and C<y> are the two rank vectors and C<i> is an index 
from one to B<n> number of samples.

=head2 kendall

  $t = $c->kendall;

         c - d
  t = -------------
      n (n - 1) / 2

Where B<c> and B<c> are the number of concordant and discordant pairs
and B<n> is the number of samples.  If there are tied pairs, a
different (more complicated) denominator is used.

=head2 csim

  $n = $c->csim;

Return the contour similarity index measure.  This is a single 
dimensional measure of the similarity between two vectors.

This returns a measure in the (inclusive) range C<[-1..1]> and is 
computed using matrices of binary data representing "higher or lower" 
values in the original vectors.

This measure has been studied in musical contour analysis.

=head1 FUNCTIONS

=head2 rank

  $v = [qw(1 3.2 2.1 3.2 3.2 4.3)];
  $ranks = rank($v);
  # [1, 4, 2, 4, 4, 6]
  my( $ranks, $ties ) = rank($v);
  # [1, 4, 2, 4, 4, 6], { 1=>[], 3.2=>[]}

Return an list of an array reference of the ordinal ranks and a hash
reference of the tied data.

In the case of a tie in the data (identical values) the rank numbers
are averaged.  An example will elucidate:

  sorted data:    [ 1.0, 2.1, 3.2, 3.2, 3.2, 4.3 ]
  ranks:          [ 1,   2,   3,   4,   5,   6   ]
  tied ranks:     3, 4, and 5
  tied average:   (3 + 4 + 5) / 3 == 4
  averaged ranks: [ 1,   2,   4,   4,   4,   6   ]

=head2 pad_vectors

  ( $u, $v ) = pad_vectors( [ 1, 2, 3, 4 ], [ 9, 8 ] );
  # [1, 2, 3, 4], [9, 8, 0, 0]

Append zeros to either input vector for all values in the other that 
do not have a corresponding value.  That is, "pad" the tail of the 
shorter vector with zero values.

=head2 co_sort

  ( $u, $v ) = co_sort( $u, $v );

Sort the vectors as two dimensional data-point pairs with B<u> values
sorted first.

=head2 correlation_matrix

  $matrix = correlation_matrix( $u );

Return the correlation matrix for a single vector.

This function builds a square, binary matrix that represents "higher 
or lower" value within the vector itself.

=head2 sign

Return 0, 1 or -1 given a number.

=head1 TO DO

Implement other rank correlation measures that are out there...

=head1 SEE ALSO

For the Jensen-Shannon divergence:

L<http://en.wikipedia.org/wiki/Jensen%E2%80%93Shannon_divergence>

=head1 THANK YOU

Juan-Manuel Torres-Moreno<lt>juan-manuel.torres@univ-avignon.fr<gt>,

=head1 AUTHOR AND COPYRIGHT

Juan-Manuel Torres-Moreno <lt>juan-manuel.torres@cpan.org<gt>

Copyright 2010, Juan-Manuel Torres-Moreno, All Rights Reserved.

=head1 LICENSE

This program is free software; you can redistribute or modify it under
the same terms as Perl itself.

=cut
