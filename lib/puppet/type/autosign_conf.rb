Puppet::Type.newtype(:autosign_conf) do
  ensurable

  newparam(:name, :namevar => true) do
    isrequired
    desc "The full or globbed certname which should be available for autosigning"
  end

  newproperty(:uuid) do
    desc "Boolean to enable UUID generation for an autosign entry"
    newvalues(true,false)
    defaultto false
  end

  newproperty(:uuid_value) do
    desc "UUID value; read-only"
  end

  newproperty(:comment) do
    desc "The comment that should be added to the autosign entry"
  end
end
