use Bio::KBase::CDMI::Client;
use Data::Dumper;

my $client = Bio::KBase::CDMI::Client->new();

$client->{client} = MyClient->new($client);

eval {
   $client->all_entities_Genome(0,10,['scientific_name']);
};
my $err = $@;
if (ref($err))
{
   my $content = $err->[0];
   print "$content\n";
}

package MyClient;
use strict;
use Data::Dumper;
use base 'JSON::RPC::Client';

sub call {
   my ($self, $uri, $obj) = @_;

   my $json = $self->json;

   $obj->{version} ||= $self->{version} || '1.1';

   if ($obj->{version} eq '1.0') {
       delete $obj->{version};
       if (exists $obj->{id}) {
           $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
       }
       else {
           $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
       }
   }
   else {
       $obj->{id} = $self->id if (defined $self->id);
   }

   my $content = $json->encode($obj);
   die [$content];
}

1;
