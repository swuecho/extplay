use Dancer2;
use Data::Dumper;
set serializer => 'JSON';

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

get '/' => sub {
    request->env;
};

post qr{/router} => sub {
    my $env = request->env;
    my $body = request->body;
    use DDP; p $body;
    my $result = from_json($body);
    delete $result->{data};
    $result->{result} = 1;
    return $result;
};

dance;
