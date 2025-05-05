import { QuartzComponentConstructor, QuartzComponentProps } from "./types";

interface Options {
  imageUrl: string;
  altText: string;
}

const defaultOptions: Options = {
  imageUrl: "/quartz/assets/profile.jpg", // Default image path
  altText: "Profile Picture",
};

const ProfilePicture: QuartzComponentConstructor = (userOpts?: Partial<Options>) => {
  const opts = { ...defaultOptions, ...userOpts };  // Merge user options with defaults

  function Component(props: QuartzComponentProps) {
    return (
      <img
        src={opts.imageUrl}
        alt={opts.altText}
        style={{ width: "250px", height: "auto", borderRadius: "50%" }}
      />
    );
  }

  return Component;
};

export default ProfilePicture;

