#!/usr/bin/perl
######################################################################
# Voronoi era un tipo raro.
######################################################################
use autodie;
use strict;
use feature "say";
use Imager;
use Getopt::Std;

=pod

=encoding utf8

=head1 Voronoi.pl

Script tonto para crear un diagrama de voronoi.

=head2 Forma de uso:

Ejecutar pasando como parametos el ancho, alto y la cantidad de celdas.

=over

=item -n (aNcho)      --> Cantidad en pixeles.

=item -l (aLto)       --> Cantidad en pixeles.

=item -c (Celdas)     --> Cantidad de celdas a crear en el diagrama.

=back

=cut

# Variables neesarias.
my $t_banana = strftime ("%d_%B_%Y_%H_%M_%S",localtime(time()));
my $ancho_default      = 100;
my $alto_default       = 100;
my $nro_celdas_default = 10;
my %opts               = ();
my $debug              = 0;
getopts( 'n:l:c:hd', \%opts );

######################################################################
# Cod_ppal.
######################################################################
$debug++ if $opts{d};
if ( $opts{h} ) {
    ayudas();
    exit;
}
$ancho_default      = $opts{n} if $opts{n};
$alto_default       = $opts{l} if $opts{l};
$nro_celdas_default = $opts{c} if $opts{c};

# Llamar a la funcion main.
_voronoi_( $ancho_default, $alto_default, $nro_celdas_default );
say "Final Feliz; Zaijian." and exit;

######################################################################
# Subs
######################################################################
# _Main_
sub _voronoi_ {
    my $ancho      = shift;
    my $alto       = shift;
    my $nro_celdas = shift;

    # Nueva imagen: 3 canales (rgb).
    my $img = Imager->new( xsize => $ancho, ysize => $alto, channels => 3 );
    my ( @nx, @ny, @nr, @ng, @nb ) = ();

    for my $i ( 0 .. $nro_celdas ) {
        push( @nx, rand($ancho) );
        push( @ny, rand($alto) );
        push( @nr, rand(256) );
        push( @ng, rand(256) );
        push( @nb, rand(256) );
    }
    for my $y ( 0 .. $alto ) {
        for my $x ( 0 .. $ancho ) {
            my $dmin = pipo_tenusa( $ancho - 1, $alto - 1 );
            my $j = -1;
            for my $i ( 0 .. $nro_celdas ) {
                my $d = pipo_tenusa( $nx[$i] - $x, $ny[$i] - $y );
                if ( $d < $dmin ) {
                    $dmin = $d;
                    $j    = $i;
                }
                my $colorin = [ $nr[$j], $ng[$j], $nb[$j] ];
                $img->setpixel( x => [$x], y => [$y], color => $colorin );
            }
        }
    }
    # Guardar Imagen.
    my $tipo_img = 'png';
    my $salida   = "voronoi_" . $t_banana . q|.| . $tipo_img;
    $img->write( file => $salida, type => $tipo_img )
      or die "No se pudo escribir $salida: ", $img->errstr;
}

# Hipotenusas.
sub pipo_tenusa {
    my $x_hip = shift;
    my $y_hip = shift;
    my $pipo  = sqrt( $x_hip**2 + $y_hip**2 );
    return $pipo;
}

sub ayudas {
    pod2usage( -verbose => 3 );
}

=pod

=head1 Autor y Licencia.

Programado por B<Marxbro> aka B<Gstv> un dia del 2014 que me quede trabajando en casa
y me aburri un poquito...
WTFPL: I<Do What the Fuck You Want To Public License>.

Zaijian.

=cut
