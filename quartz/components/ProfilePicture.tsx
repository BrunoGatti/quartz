import { QuartzComponentConstructor, QuartzComponentProps } from "./types";

interface Options {
  imageUrl: string;
  altText: string;
}

const defaultOptions: Options = {
  imageUrl: "./assets/profile.jpg",
  altText: "Profile Picture",
};

const ProfilePicture: QuartzComponentConstructor = (userOpts?: Partial<Options>) => {
  const opts = { ...defaultOptions, ...userOpts };

  function Component(props: QuartzComponentProps) {
    // Check if the current page is the index page
    if (props.filePath !== "index.md") {
      return null; // Don't render if it's not the index page
    }

    return (
      <img
        src={opts.imageUrl}
        alt={opts.altText}
        style={{ width: "100px", height: "auto", borderRadius: "50%" }}
      />
    );
  }

  return Component;
};

export default ProfilePicture;

