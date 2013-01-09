package Bot::BasicBot::Pluggable::Module::Insult;

use strict;
use Bot::BasicBot::Pluggable::Module; 
use base qw(Bot::BasicBot::Pluggable::Module);


#use Net::Telnet;
use  Acme::Scurvy::Whoreson::BilgeRat;
use Lingua::Translate;
use Text::Unidecode;
use Convert::Morse qw(as_morse is_morsable);
use Convert::Braille qw(brailleUnicodeToDots brailleAsciiToDots);


our %languages = (
    'bulgarian'      => 'bg',
    'brazilian'      => 'pt-br',
    'chinese'        => 'zh',
    'croatian'       => 'hr',
    'czech'          => 'cs',
    'danish'         => 'da',
    'dutch'          => 'nl',
    'english'        => 'en',
    'filipino'       => 'tl',
    'finnish'        => 'fi',
    'french'         => 'fr',
    'german'         => 'de',
    'greek'          => 'el',
    'hungarian'      => 'hu',
    'icelandic'      => 'is',
    'italian'        => 'it',
    'japanese'       => 'ja',
    'korean'         => 'ko',
    'latin'          => 'la',
    'latin-american' => 'es-us',
    'norwegian'      => 'no',
    'polish'         => 'pl',
    'portugese'      => 'pt-pt',
    'romanian'       => 'ro',
    'russian'        => 'ru',
    'serbian'        => 'sr',
    'slovenian'      => 'sl',
    'spanish'        => 'es-es',
    'swedish'        => 'sv',
    'tagalog'        => 'tl',
    'turkish'        => 'tr', 
    'welsh'          => 'cy',
    
    'morse'          => 1,
    'braille'        => 1,    
);


sub init {
    my $self = shift;
    $self->set("user_unidecode", 0) unless defined($self->get("user_unidecode"));
}

sub said { 
    my ($self, $mess, $pri) = @_;

    my $body = $mess->{body}; 
    my $who  = $mess->{who};

    return unless ($pri == 2);


    return unless $body =~ /^\s*insult (.*)\s*$/;
    my $person   = $1;
    my $language = "english";

    if ($person =~ s/ in (.+)$//i) {
    #if ($person =~ s/ in ([a-z]+)\s*\w*\s*//i) {
        $language = lc($1);
    }

    $language = "morse" if $language =~ m!^morse\s*code!;

    return "I don't speak ".join(" ", map { ucfirst($_) } split ' ', $language) unless $languages{$language};
 
    $person = $who if $person =~ /^\s*me\s*$/i;

    my $insultgenerator = Acme::Scurvy::Whoreson::BilgeRat->new( language => 'insultserver' );

    my $insult = "$insultgenerator";    

    
    return "Errk, the insult code is mysteriously not working" unless defined $insult;

    $insult =~ s/^\s*You are/$person is/i if ($person ne $who);  


    return $insult if $language eq 'english';
    
    if ("braille" eq $language) {
        return brailleAsciiToDots(uc($insult));
    }

    if ("morse" eq $language) {
        my $converted = unidecode($insult);
        return "For some bizarre reason the (possibly unidecoded) insult '$insult' is not morseable\n" unless is_morsable($converted);
        return as_morse($converted);   
    }
    
    
    my %config = map { $_ => $self->get("user_${_}") }  map { my $mod = $_; $mod =~ s/^user_// ? $mod : () } $self->store_keys( res => ["^user"] );
    
    my $xl8r = Lingua::Translate->new(src => "en", dest => $languages{$language}, %config)
         or return $insult;

    my $translated_insult; 
    eval {  
            $translated_insult = $xl8r->translate($insult);
    };
    $translated_insult = $insult if $@;

    $translated_insult = unidecode($translated_insult) if $self->get("user_unidecode");
    return $translated_insult;

}

sub help {
    my $languages = join(", ", map { ucfirst($_) } sort keys %languages);
    return "Commands: 'insult <who> [in <language>]' - I speak $languages";
}

1;


__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Insult - insult people (in a variety of languages)

=head1 SYNOPSIS


=head1 IRC USAGE

    insult <who> [in <language>]

=head1 AUTHOR

Simon Wistow, <simon@thegestalt.org>

=head1 COPYRIGHT

Copyright 2005, Simon Wistow

Distributed under the same terms as Perl itself.

=head1 SEE ALSO

L<Math::Units>

=cut 

