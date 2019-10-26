program animation_test;

{$MODE objfpc}

uses SysUtils, raylib, rlgl;

const
	screenWidth = 800;
	screenHeight = 450;

var
  cam: TCamera;
  model : TModel;
  texture : TTexture2D;
  position : TVector3;
  animsCount, animFrameCounter : Integer;
  anims : PModelAnimation;
  i : Integer;
begin

	InitWindow(screenWidth, screenHeight, 'Animation Test');	

	cam.position := TVector3.Create(10.0, 10.0, 10.0);
	cam.target := TVector3.Create(0.0, 0.0, 0.0);
	cam.up := TVector3.Create(0.0, 1.0, 0.0);
	cam.fovy := 45.0;
	cam.&type := CAMERA_PERSPECTIVE;

	model := LoadModel('res/guy/guy.iqm');
	texture := LoadTexture('res/guy/guytex.png');
	SetMaterialTexture(@model.materials[0], MAP_DIFFUSE, texture);

	position := TVector3.Create(0.0, 0.0, 0.0);

	// Load Animation Data
	animsCount := 0;
	anims := LoadModelAnimations('res/guy/guyanim.iqm', @animsCount);
	animFrameCounter := 0;

	WriteLn('animsCount: ', animsCount);

	SetCameraMode(cam, CAMERA_FREE);

	SetTargetFPS(60);

	while not WindowShouldClose() do
	begin
		// Test that we are receiving the Struct data back correctly (YES)
		//mousePos := GetMousePosition();
		//WriteLn('Mouse Pos: ', FloatToStr(mousePos.x), ', ', FloatToStr(mousePos.y));

		UpdateCamera(cam);

		if IsKeyDown(KEY_SPACE) then
		begin
			inc(animFrameCounter);
			UpdateModelAnimation(model, anims[0], animFrameCounter);
			if animFrameCounter >= anims[0].frameCount then
				animFrameCounter := 0;
		end;

		BeginDrawing();
			ClearBackground(RAYWHITE);
			BeginMode3d(cam);
		
				DrawModelEx(model, position, TVector3.Create(1.0, 0.0, 0.0), -90.0, TVector3.Create(1.0, 1.0, 1.0), WHITE);
				for i := 0 to model.boneCount - 1 do
				begin
				  DrawCube(anims[0].framePoses[animFrameCounter][i].translation, 0.2, 0.2, 0.2, RED);
				end;
				DrawGrid(10, 1.0);
		
		
			EndMode3D();
			DrawFPS(10, 10);
		EndDrawing();
	end;
	UnloadTexture(texture);
	for i := 0 to animsCount - 1 do
		UnloadModelAnimation(anims[i]);
	
    // Not sure how to handle freeing this yet
    //   Maybe I need to have a call to c-runtime free
	//FreeMem(anims);

	UnloadModel(model);


	CloseWindow();
end.