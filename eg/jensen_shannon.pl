#  	Juan-Manuel Torres-Moreno LIA/Avignon   juan-manuel.torres@univ-avignon.fr
use strict  ;
use JS ;   						# Module Jensen_Shannon

my $A = "la plume de ma tante est la plus jolie" ; # Doc 1
my $B = "la plume est jolie" ; 					# Doc 2

my %A = unigrammes(split(/ /,$A));		# 1-grammes
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