package Catalyst::Plugin::Sitemap;

use strict;
use warnings;

use Moose::Role;

no warnings qw/uninitialized/;

use Search::Sitemap;
use List::Util qw/ first /;

sub sitemap {
    my $self = shift;

    my $sitemap = Search::Sitemap->new;
    $sitemap->pretty(1);

    for my $controller ( $self->controller(qr//) ) {
      ACTION:
        for my $a ( $controller->get_action_methods ) {

            my $action = $controller->action_for( $a->name );

            my $attr = $action->attributes->{Sitemap} or next ACTION;

            die "more than one attribute 'Sitemap' for sub ",
              $a->fully_qualified_name
              if @$attr > 1;

            my @attr = split /\s*(?:,|=>)\s*/, $attr->[0];

            my %uri_params;

            if ( @attr == 1 ) {
                if ( $attr[0] eq '*' ) {
                    my $sitemap_method = $action->name . "_sitemap";

                    if ( $controller->can($sitemap_method) ) {
                        $controller->$sitemap_method( $self, $sitemap );
                        next ACTION;
                    }
                }

                if ( $attr[0] + 0 > 0 ) {
                    # it's a number
                    $uri_params{priority} = $attr[0];
                }

            }
            elsif ( @attr > 0 ) {
                %uri_params = @attr;
            }

            $uri_params{loc} = $self->uri_for_action( $action->private_path );

            $sitemap->add( \%uri_params );

            next ACTION;
        }

    }

    return $sitemap;
}

1;

__END__

ways I can do it

is Sitemap( <yadah> ) ? => use it as is
else => has <action>_sitemap? => use it
else => use the uri directly


sitemap => sub {
    my ( $self, $c, $sitemap ) = @_;

    ...
};

sub action_sitemap {
    my ( $self, $c, $sitemap ) = @_;
}

sub do_stuff :Local :Sitemap {
}
