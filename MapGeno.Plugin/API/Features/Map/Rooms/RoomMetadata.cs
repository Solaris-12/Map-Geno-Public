namespace MapGeno.API.Features.Map.Rooms
{
    public class RoomMetadata
    {
        public string Name { get; set; }
        public string Author { get; set; }
        public string Description { get; set; }
        public string Version { get; set; }

        public RoomMetadata(string name = "", string author = "", string description = "", string version = "")
        {
            this.Name = name;
            this.Author = author;
            this.Description = description;
            this.Version = version;
        }
    }
}
