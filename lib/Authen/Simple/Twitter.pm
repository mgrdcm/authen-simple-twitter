package Authen::Simple::Twitter;

use warnings;
use strict;

use base 'Authen::Simple::Adapter';

__PACKAGE__->options(
    {
        identica => {
            type     => Params::Validate::BOOLEAN,
            default  => undef,
            optional => 1
        }
    }
);

__PACKAGE__->mk_accessors(qw[ net_twitter ]);

use Net::Twitter;

=head1 NAME

Authen::Simple::Twitter - Simple authentication using Twitter or Identica

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Authen::Simple::Twitter;

    my $twitauth = Authen::Simple::Twitter->new();

    if ( $dbi->authenticate( $username, $password ) ) {
        # successful authentication
    }

=head1 FUNCTIONS


=head2 check

=cut

sub check {
    my ( $self, $username, $password ) = @_;

    $self->net_twitter->credentials(
        $username, $password,
        $self->net_twitter->{apihost},
        $self->net_twitter->{apirealm}
    );

    if ( my $response = $self->net_twitter->verify_credentials() ) {

        $self->log->debug(qq/Successfully authenticated user '$username'./)
          if $self->log;

        return 1;
    }

    $self->log->debug(
qq/Failed to authenticate user '$username'. Reason: 'Invalid credentials'/
    ) if $self->log;

    return 0;
}

=head2 init

=cut

sub init {
    my ( $self, $parameters ) = @_;

    my $initret = $self->SUPER::init($parameters);

    $self->net_twitter( Net::Twitter->new( { identica => $self->identica } ) );

    return $initret;
}

=head1 AUTHOR

Dan Moore, C<< <dan at moore.cx> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-authen-simple-twitter at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Authen-Simple-Twitter>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Authen::Simple::Twitter


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Authen-Simple-Twitter>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Authen-Simple-Twitter>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Authen-Simple-Twitter>

=item * Search CPAN

L<http://search.cpan.org/dist/Authen-Simple-Twitter/>

=back


=head1 ACKNOWLEDGEMENTS

This module is pretty close to 1 line of code.  All the real functionality is in L<Net::Twitter> and L<Authen::Simple>.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dan Moore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of Authen::Simple::Twitter
