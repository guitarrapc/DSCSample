# Chef Recipe rule

[cookbook] 'Nae' do
  [Key_name] "[key_value]"
  [value_name] "[value_value]"
end

# Chef DSC call EnvironemtResource with : https://github.com/opscode-cookbooks/dsc

env 'editor' do
    key_name "EDITOR"
    value    "vim"
end


# DSC Configuration Sample

environment editor
{
    Name = "EDITOR"
    Value = "vim"
}