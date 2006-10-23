package Bot::BasicBot::Pluggable::Module::Toasts;

use strict;
use Bot::BasicBot::Pluggable::Module; 
use base qw(Bot::BasicBot::Pluggable::Module);
use POSIX qw(strftime);

sub said { 
    my ($self, $mess, $pri) = @_;

    my $body = $mess->{body}; 
    my $who  = $mess->{who};

    return unless ($pri == 2);

    return unless $body =~  /^((a|the)\s+)?toast(\s+for\s+([a-z]+day))?!*$/i;
    my $day = (defined $4)? $4 : strftime("%A", localtime);
    $day    = ucfirst(lc($day));

    
    my %toasts = (
    Sunday    => "Absent friends",
    Monday    => "Our ships at sea",
    Tuesday   => "Our men",
    Wednesday => "Ourselves (as no one else is likely to concern themselves with our welfare)",
    Thursday  => "A bloody war or a sickly season",
    Friday    => "A willing foe and sea room",
    Saturday  => "Sweethearts and wives (may they never meet)",
    );
    return "I can't toast $day! There's no such day! Damn yer eyes!" unless defined $toasts{$day};
    return $toasts{$day}."!";
    

}

sub help {
    return "Commands: a toast! or toast for <day of the week>!";
}

1;

=head1 NAME

Bot::BasicBot::Pluggable::Module::Toasts - exclaim British Naval toasts.


=head1 SYNOPSIS



=head1 IRC USAGE

    a toast! 
    a toast for <day of the week>!

=head1 AUTHOR

Simon Wistow, <simon@thegestalt.org>

=head1 COPYRIGHT

Copyright 2006, Simon Wistow

Distributed under the same terms as Perl itself.

=head1 SEE ALSO


=cut 

