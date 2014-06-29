use Dancer2;
use Data::Dumper;
set serializer => 'JSON';
my $metadata;
# find a solution to auto generate ECHO_REMOTING_API
my $ECHO_REMOTING_API = {
    "url"     => "/router",
    "type"    => "remoting",
    "actions" => {
        "AlbumList" => [
            {
                "name" => "getAll",
                "len"  => 0
            },
            {
                "name" => "add",
                "len"  => 1
            }
        ]
    }
};

get '/ext-api' => sub {
     content_type 'text/javascript';
     return 'Ext.ns("Ext.app"); Ext.app.REMOTING_API = ' . to_json($ECHO_REMOTING_API); 
};

sub run {
    my $call = shift;
    my $action = $call->{action};
    my $method = $call->{method};
    my $data = $call->{data};
    my $tid = $call->{tid};
    # should check if this method is exist
    my $package = $action;
    # distinguis class method( subroutine? ) or object method? 
    my $obj = $package->new();
    # should have more?
    my $result = $obj->$method(ref($data) eq "ARRAY" ? @$data : ());

    return {
	type => 'rpc',
	tid => $request->{tid},
	action => $action,
	method => $method,
	result => $result,
    };

}

post qr{/router} => sub {
    my $env = request->env;
    my $body = request->body;
    use DDP; p $body;
    my $data = from_json($body);
    $data = [ $data ] if ref($data) ne 'ARRAY';
    my @result = map { run($_) } @$data;
};

dance;
