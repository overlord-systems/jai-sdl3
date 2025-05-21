#import "Basic";
#import,file "../windows/windows.jai";

main :: () {

    success := SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    print("sdl3 init status = %\n", success);

    window: *SDL_Window;
    renderer: *SDL_Renderer;
    success = SDL_CreateWindowAndRenderer("SDL3 from Jai", 1920, 1080, SDL_WINDOW_OPENGL, *window, *renderer);
    print("sdl3 window create status = %\n", success);

    is_running := true;

    while is_running {

        ev: SDL_Event;
        while(SDL_PollEvent(*ev)) {

            if ev.type == {

                case xx SDL_EventType.QUIT;
                    is_running = false;

                case xx SDL_EventType.KEY_DOWN;
                    if ev.key.key == SDLK_ESCAPE
                        is_running = false;
                case;
            }
        }
    }
}
