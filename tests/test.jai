#import "Basic";
#import,file "../windows/windows.jai";

main :: () {

    success := SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    print("SDL3 init status = %\n", success);
}
