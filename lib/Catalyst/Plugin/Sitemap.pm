package Catalyst::Plugin::Sitemap;
# ABSTRACT: Sitemap support for Catalyst.

=head1 SYNOPSIS

    # in MyApp.pm

    use Catalyst qw/ Sitemap /;

    # in the controller
    
    sub alone :Local :Sitemap { 
        ... 
    }
    
    sub with_priority :Local :Sitemap(0.75) {
        ... 
    }
    
    sub with_args :Local
            :Sitemap( lastmod => 2010-09-27, changefreq => daily ) {
        ...
    }
    
    sub with_function :Local :Sitemap(*) { 
        ... 
    }
    
    sub with_function_sitemap {
        $_[2]->add( 'http://localhost/with_function' );
    }

    # and then...
    
    sub sitemap : Path('/sitemap') {
        my ( $self, $c ) = @_;
 
        $c->res->body( $c->sitemap->as_xml->sprint );
    }

=head1 DESCRIPTION

L<Catalyst::Plugin::Sitemap> provides a way to semi-automate the creation 
of the sitemap of a Catalyst application.

=head1 CONTEXT METHOD

=head2 sitemap()

Returns a L<WWW::Search::XML> object. The sitemap object is populated by 
inspecting the controllers of the application for actions with the 
sub attribute C<:Sitemap>.

=head1 C<:Sitemap> Subroutine Attribute

The sitemap is populated by actions ear-marked with the <:Sitemap> sub
attribute.  It can be invoked in different ways:

=over

=item C<:Sitemap>

    sub alone :Local :Sitemap {
        ...
    }

Adds the url of the action to the sitemap.  

If the action does not
resolves in a single url, this will results in an error.

=item C<:Sitemap($priority)>


    sub with_priority :Local :Sitemap(0.9) {
        ...
    }

Adds the url, with the given number, which has to be between 1 (inclusive)
and 0 (exclusive), as its priority.

If the action does not
resolves in a single url, this will results in an error.

=item C<:Sitemap( %attributes )>

    sub with_args :Local
            :Sitemap( lastmod => 2010-09-27, changefreq => daily ) {
        ...
    }

Adds the url with the given entry attributes (as defined by
L<WWW::Search::XML::URL>).

If the action does not
resolves in a single url, this will results in an error.

=item C<:Sitemap(*)>

    sub with_function :Local :Sitemap(*) { }
    
    sub with_function_sitemap {
        my ( $self, $c, $sitemap ) = @_;

        $sitemap->add( 'http://localhost/with_function' );
    }

Calls the function 'I<action>_sitemap', if it exists, and passes it the
controller, context and sitemap objects.

This is currently the only way to invoke C<:Sitemap> on an action 
resolving to many urls. 

=back


=head1 BUGS AND LIMITATIONS

Currently, each invocation of the method C<sitemap()> will 
re-generate the C<WWW::Sitemap::XML> object.  A future version
of this module might offer a way to only compute the sitemap
once.


=head1 SEE ALSO

=over 

=item L<WWW::Sitemap::XML>

Module that C<Catalyst::Plugin::Sitemap> uses under the hood.

=item L<Dancer::Plugin::SiteMap>

Similar plugin for the L<Dancer> framework, which inspired
C<Catalyst::Plugin::Sitemap>. 

=item http://babyl.dyndns.org/techblog/entry/catalyst-plugin-sitemap

Blog article introducing C<Catalyst::Plugin::Sitemap>.

=back

=cut

use strict;
use warnings;

use Moose::Role;

no warnings qw/uninitialized/;

use WWW::Sitemap::XML;
use List::Util qw/ first /;

sub sitemap {
    my $self = shift;

    my $sitemap = WWW::Sitemap::XML->new;

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
